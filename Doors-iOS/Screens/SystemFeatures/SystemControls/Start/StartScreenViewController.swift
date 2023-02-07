//
//  StartScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class StartScreenViewController: BaseSystemFeatureMenuViewController {

    private var features = [UserFeature]()
    
    // MARK: - Setup
    
    override func setupData() {
        super.setupData()
        if let features = core.rootCore.appManager.featureMap?.features.first(where: { $0.name == "main" })?.childFeatures {
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) != nil {
                    self.features = features
                } else if systemControlsFeature.dependencies.first(where: { $0.name == "session" }) != nil {
                    self.features = features.filter({ $0.name != "export" })
                }
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StartFeatureCell.self, forCellReuseIdentifier: "StartFeatureCell")
    }
}

extension StartScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StartFeatureCell.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
            if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if userViewController.user.rootSessionConfiguration.features.firstIndex(where: { $0.name == features[indexPath.row].name }) != nil {
                        (cell as? StartFeatureCell)?.isDisabled = true
                    } else {
                        (cell as? StartFeatureCell)?.isDisabled = false
                    }
                }
            } else if let sessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "session" }) {
                if let userViewController = sessionFeature.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if let sessionId = (sessionFeature as? SessionFeature)?.sessionId {
                        if userViewController.user.rootSessionConfiguration.sessionConfigurations.firstIndex(where: { $0.id == sessionId }) != nil {
                            if userViewController.user.rootSessionConfiguration.sessionConfigurations.first(where: { $0.id == sessionId })?.features.firstIndex(where: { $0.name == features[indexPath.row].name }) != nil {
                                (cell as? StartFeatureCell)?.isDisabled = true
                            } else {
                                (cell as? StartFeatureCell)?.isDisabled = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch features[indexPath.row].name {
        case "console":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                        if let index = userViewController.user.rootSessionConfiguration.features.firstIndex(where: { $0.name == features[indexPath.row].name }) {
                            userViewController.user.rootSessionConfiguration.features.remove(at: index)
                            (rootSessionFeature.viewController as? RootSessionViewController)?.unloadFeature(name: "console")
                        } else {
                            userViewController.user.rootSessionConfiguration.features.append(features[indexPath.row].simple)
                            (rootSessionFeature.viewController as? RootSessionViewController)?.loadFeature(name: "console")
                        }
                        userViewController.saveUser()
                    }
                } else if let sessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "session" }) {
                    if let userViewController = sessionFeature.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                        if let sessionId = (sessionFeature as? SessionFeature)?.sessionId {
                            if let sessionIndex = userViewController.user.rootSessionConfiguration.sessionConfigurations.firstIndex(where: { $0.id == sessionId }) {
                                if let indexToRemove = userViewController.user.rootSessionConfiguration.sessionConfigurations.first(where: { $0.id == sessionId })?.features.firstIndex(where: { $0.name == features[indexPath.row].name }) {
                                    userViewController.user.rootSessionConfiguration.sessionConfigurations[sessionIndex].features.remove(at: indexToRemove)
                                    (sessionFeature.viewController as? SessionViewController)?.unloadFeature(name: "console")
                                } else {
                                    userViewController.user.rootSessionConfiguration.sessionConfigurations[sessionIndex].features.append(features[indexPath.row].simple)
                                    (sessionFeature.viewController as? SessionViewController)?.loadFeature(name: "console")
                                }
                                userViewController.saveUser()
                            }
                        }
                    }
                }
                tableView.reloadData()
            }
        case "export":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                var rootSessionFeature: Feature?
                if let feature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    rootSessionFeature = feature
                } else if let feature = systemControlsFeature.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" }) {
                    rootSessionFeature = feature
                }
                if let feature = (rootSessionFeature?.viewController as? RootSessionViewController)?.loadFeature(name: "export") {
                    onClose() {
                        (feature.viewController as? ExportViewController)?.closeAction?()
                    }
                }
            }
        default:
            break
        }
    }
}

extension StartScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StartFeatureCell", for: indexPath) as? StartFeatureCell {
            cell.configure(feature: features[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

final class StartFeatureCell: TableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(feature: UserFeature) {
        textLabel?.textAlignment = .center
        textLabel?.textColor = .white
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        textLabel?.text = feature.title?.localized(tableName: "Feature")
    }
}

