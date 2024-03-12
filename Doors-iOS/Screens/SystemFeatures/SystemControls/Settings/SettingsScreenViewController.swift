//
//  SettingsScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsScreenViewController: BaseSystemFeatureMenuViewController {
    
    private var features = [UserFeature]()
    
    private var rootSessionFeature: Feature? {
        let rootSessionFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "rootSession" })
        if let rootSessionFeature = rootSessionFeature {
            return rootSessionFeature
        } else {
            return feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })
        }
    }
    
    // MARK: Setup
    
    override func setupData() {
        features.removeAll()
        
        super.setupData()
        
        var filteredSettingsFeatures = [UserFeature]()
        if let allSettingsFeatures = (rootSessionFeature?.childFeatures.first(where: { $0.name == "user"})?.viewController as? UserViewController)?.user.rootDomain.featureMap.settingsFeatures.filter({ $0.isAdded }) {
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) != nil {
                    filteredSettingsFeatures = allSettingsFeatures
                } else if systemControlsFeature.dependencies.first(where: { $0.name == "session" }) != nil {
                    filteredSettingsFeatures = allSettingsFeatures.filter({ ["importExport", "reset", "auth"].contains($0.name) == false })
                }
            }
        } else if let allSettingsFeatures = (rootSessionFeature?.childFeatures.first(where: { $0.name == "user"})?.viewController as? UserViewController)?.user.rootDomain.featureMap.settingsFeatures.filter({ $0.isAdded }) {
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) != nil {
                    filteredSettingsFeatures = allSettingsFeatures
                } else if systemControlsFeature.dependencies.first(where: { $0.name == "session" }) != nil {
                    filteredSettingsFeatures = allSettingsFeatures.filter({ ["importExport", "reset", "auth"].contains($0.name) == false })
                }
            }
        }
        
        filteredSettingsFeatures.forEach { settingFeature in
            switch settingFeature.name {
            case "multiSession":
                setupMultiSession()
            case "console":
                features.append(settingFeature)
            case "importExport":
                features.append(settingFeature)
                features.append(settingFeature)
            case "reset":
                features.append(settingFeature)
            case "auth":
                features.append(settingFeature)
            default:
                break
            }
        }
        
        if let feature = makeChildFeature(name: "setup") {
            features.append(feature)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        updateHeight(contentHeight: CGFloat(features.count * Int(SettingCell.height)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    private func setupMultiSession() {
        if let rootSessionFeature = rootSessionFeature {
            if let sessionsCount = (rootSessionFeature.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
                if let feature = makeChildFeature(name: "addSession") {
                    features.append(feature)
                }
            }
        } else if let sessionsCount = (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
            if let feature = makeChildFeature(name: "addSession") {
                features.append(feature)
            }
        }
        if feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" }) != nil {
            if let feature = makeChildFeature(name: "dropSession") {
                features.append(feature)
            }
        }
    }
    
    func makeChildFeature(name: String) -> UserFeature? {
        return UserFeature(name: name, title: nil, dependencies: nil, childFeatures: nil, accessGroup: .free, isAdded: true, isEnabled: true)
    }
}

extension SettingsScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch features[indexPath.row].name {
        case "addSession":
            if let rootSessionFeature = rootSessionFeature {
                (rootSessionFeature.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.addSession()
            }
            (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.addSession()
            onClose()
        case "dropSession":
            (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.viewController as? SessionViewController)?.dropSession()
            onClose()
        case "console":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
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
            }
        case "import":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settingsScreen" })?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = rootSessionFeature {
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
                if let rootSessionFeature = rootSessionFeature {
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
        case "setup":
            guard let feature = feature else { return }
            let settingsSetupFeature = Feature(name: "setup", dependencies: [feature])
            let settingsSetupScreenViewController = SettingsSetupScreenViewController(core: core, feature: settingsSetupFeature)
            navigationController?.pushViewController(settingsSetupScreenViewController, animated: false)
        default:
            break
        }
    }
}

extension SettingsScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell {
            cell.configure(feature: features[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension SettingsScreenViewController: MenuTableViewCellDelegate {
    
    func onToggleAddition(_ index: Int) {
        
    }
    
    func onToggleEnabling(_ index: Int) {
        
    }
}

final class SettingCell: MenuTableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(feature: UserFeature) {
        toggleAdditionButton.isHidden = true
        isDisabled = !feature.isEnabled
        toggleEnablingButton.isHidden = true
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        switch feature.name {
        case "addSession":
            arrowLabel.isHidden = true
            titleLabel.text = "Add Session".localized(tableName: "Settings")
        case "dropSession":
            arrowLabel.isHidden = true
            titleLabel.text = "Drop Session".localized(tableName: "Settings")
        case "console":
            arrowLabel.isHidden = true
            titleLabel.text = "Console".localized(tableName: "Settings")
        case "setup":
            arrowLabel.isHidden = false
            titleLabel.text = "Setup".localized(tableName: "Settings")
        default:
            arrowLabel.isHidden = feature.childFeatures?.isEmpty ?? true
            titleLabel.text = feature.name
        }
    }
}
