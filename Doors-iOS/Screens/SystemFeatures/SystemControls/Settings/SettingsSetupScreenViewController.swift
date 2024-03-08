//
//  SettingsSetupScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 07/03/2024.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsSetupScreenViewController: BaseSystemFeatureMenuViewController {

    private var features = [UserFeature]()
    
    // MARK: Setup
    
    override func setupData() {
        super.setupData()
        if let settingsFeatures = core.rootCore.appManager.featureMap?.settingsFeatures {
            features = settingsFeatures
        }
    }
    
    override func setupUI() {
        super.setupUI()
        updateHeight(contentHeight: CGFloat(features.count * Int(FeatureCell.height)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeatureCell.self, forCellReuseIdentifier: "FeatureCell")
    }
}

extension SettingsSetupScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeatureCell.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
            if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if userViewController.user.rootSessionConfiguration.features.firstIndex(where: { $0.name == features[indexPath.row].name }) != nil {
                        (cell as? FeatureCell)?.isDisabled = true
                    } else {
                        (cell as? FeatureCell)?.isDisabled = false
                    }
                }
            } else if let sessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "session" }) {
                if let userViewController = sessionFeature.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if let sessionId = (sessionFeature as? SessionFeature)?.sessionId {
                        if userViewController.user.rootSessionConfiguration.sessionConfigurations.firstIndex(where: { $0.id == sessionId }) != nil {
                            if userViewController.user.rootSessionConfiguration.sessionConfigurations.first(where: { $0.id == sessionId })?.features.firstIndex(where: { $0.name == features[indexPath.row].name }) != nil {
                                (cell as? FeatureCell)?.isDisabled = true
                            } else {
                                (cell as? FeatureCell)?.isDisabled = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feature = feature else { return }
        let startScreenFeature = Feature(name: "startScreen", dependencies: feature.dependencies)
        let startScreenViewController = StartScreenViewController(core: core, feature: startScreenFeature)
        startScreenFeature.viewController = startScreenViewController
        
        navigationController?.pushViewController(startScreenViewController, animated: false)
    }
}

extension SettingsSetupScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureCell {
            cell.configure(feature: features[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension SettingsSetupScreenViewController: MenuTableViewCellDelegate {
    
    func onToggleAddition(_ index: Int) {
        switch features[index].name {
        case "console":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                        if let index = userViewController.user.rootSessionConfiguration.features.firstIndex(where: { $0.name == features[index].name }) {
                            userViewController.user.rootSessionConfiguration.features.remove(at: index)
                            (rootSessionFeature.viewController as? RootSessionViewController)?.unloadFeature(name: "console")
                        } else if let consoleFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "console")  {
                            userViewController.user.rootSessionConfiguration.features.append(features[index].simple)
                            loadChildFeature(consoleFeature)
                        }
                        userViewController.saveUser()
                    }
                } else if let sessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "session" }) {
                    if let userViewController = sessionFeature.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                        if let sessionId = (sessionFeature as? SessionFeature)?.sessionId {
                            if let sessionIndex = userViewController.user.rootSessionConfiguration.sessionConfigurations.firstIndex(where: { $0.id == sessionId }) {
                                if let indexToRemove = userViewController.user.rootSessionConfiguration.sessionConfigurations.first(where: { $0.id == sessionId })?.features.firstIndex(where: { $0.name == features[index].name }) {
                                    userViewController.user.rootSessionConfiguration.sessionConfigurations[sessionIndex].features.remove(at: indexToRemove)
                                    (sessionFeature.viewController as? SessionViewController)?.unloadFeature(name: "console")
                                } else {
                                    userViewController.user.rootSessionConfiguration.sessionConfigurations[sessionIndex].features.append(features[index].simple)
                                    (sessionFeature.viewController as? SessionViewController)?.loadFeature(name: "console")
                                }
                                userViewController.saveUser()
                            }
                        }
                    }
                }
                tableView.reloadData()
            }
        case "import":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let importFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "import") {
                        (importFeature.viewController as? ImportViewController)?.run()
                        onBack() {
                            (importFeature.viewController as? ImportViewController)?.run()
                        }
                    }
                }
            }
        case "export":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let exportFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "export") {
                        onBack() {
                            (exportFeature.viewController as? ExportViewController)?.run()
                        }
                    }
                }
            }
        case "reset":
            print("\n[TODO] [RESET] Do you really want to reset current user?")
            try? core.rootCore.fileSystemManager.removeFile(fileName: "Doors", fileFormat: "")
            UIApplication.rootViewController?.reloadRootSesion()
        default:
            break
        }
    }
    
    func onToggleEnabling(_ index: Int) {
        
    }
}
