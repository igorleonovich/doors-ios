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
    
    private var rootSessionFeature: Feature? {
        let rootSessionFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "rootSession" })
        if let rootSessionFeature = rootSessionFeature {
            return rootSessionFeature
        } else {
            return feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })
        }
    }
    
    // MARK: Setup
    
    override func setupData() {
        super.setupData()
        if let allSettingsFeatures = (rootSessionFeature?.childFeatures.first(where: { $0.name == "user"})?.viewController as? UserViewController)?.user.rootDomain.featureMap.settingsFeatures {
            features = allSettingsFeatures
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
        (cell as? TableViewCell)?.isDisabled = !features[indexPath.row].isAdded
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
            if let rootSessionFeature = rootSessionFeature {
                if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if let consoleFeature = userViewController.user.rootDomain.featureMap.settingsFeatures.first(where: { $0.name == "console" }) {
                        if consoleFeature.isAdded {
                            if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "console" }) {
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isAdded = false
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = false
                            }
                            (rootSessionFeature.viewController as? RootSessionViewController)?.unloadFeature(name: "console")
                        } else if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "console" }), let consoleFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "console") {
                            userViewController.user.rootDomain.featureMap.settingsFeatures[index].isAdded = true
                            userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = true
                            (rootSessionFeature.viewController as? RootSessionViewController)?.loadChildFeature(consoleFeature)
                        }
                        userViewController.saveUser()
                    }
                }
            }
            setupData()
            tableView.reloadData()
        case "multiSession":
            if let rootSessionFeature = rootSessionFeature {
                if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if let multiSessionFeature = userViewController.user.rootDomain.featureMap.settingsFeatures.first(where: { $0.name == "multiSession" }) {
                        if multiSessionFeature.isAdded {
                            if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "multiSession" }) {
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isAdded = false
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = false
                                dropSessions()
                            }
                        } else if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "multiSession" }) {
                            userViewController.user.rootDomain.featureMap.settingsFeatures[index].isAdded = true
                            userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = true
                        }
                        userViewController.saveUser()
                    }
                }
            }
            setupData()
            tableView.reloadData()
            
            func dropSessions() {
                if let sessionFeatures = rootSessionFeature?.childFeatures.first(where: { $0.name == "sessions" })?.childFeatures.filter({ $0.name == "session" }) {
                    sessionFeatures.enumerated().forEach { index, sessionFeature in
                        guard index > 0 else { return }
                        (sessionFeature.viewController as? SessionViewController)?.dropSession()
                    }
                }
            }
        default:
            break
        }
    }
    
    func onToggleEnabling(_ index: Int) {
        guard features[index].isAdded else { return }
        switch features[index].name {
        case "console":
            if let rootSessionFeature = rootSessionFeature {
                if let userViewController = rootSessionFeature.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController {
                    if let consoleFeature = userViewController.user.rootDomain.featureMap.settingsFeatures.first(where: { $0.name == "console" }) {
                        if consoleFeature.isEnabled {
                            if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "console" }) {
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = false
                            }
                            (rootSessionFeature.viewController as? RootSessionViewController)?.unloadFeature(name: "console")
                        } else if let consoleFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "console")  {
                            if let index = userViewController.user.rootDomain.featureMap.settingsFeatures.firstIndex(where: { $0.name == "console" }) {
                                userViewController.user.rootDomain.featureMap.settingsFeatures[index].isEnabled = true
                            }
                            (rootSessionFeature.viewController as? RootSessionViewController)?.loadChildFeature(consoleFeature)
                        }
                        userViewController.saveUser()
                    }
                }
            }
            setupData()
            tableView.reloadData()
        default:
            break
        }
    }
}
