//
//  SettingsScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsScreenViewController: BaseSystemFeatureMenuViewController {
    
    private var settings = [Setting]()
    
    // MARK: Setup
    
    override func setupData() {
        super.setupData()
        var settingFeatures = [UserFeature]()
        if let allSettingFeatures = core.rootCore.appManager.featureMap?.settingsFeatures {
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) != nil {
                    settingFeatures = allSettingFeatures
                } else if systemControlsFeature.dependencies.first(where: { $0.name == "session" }) != nil {
                    settingFeatures = allSettingFeatures.filter({ ["importExport", "reset", "auth"].contains($0.name) == false })
                }
            }
        }
        
        settingFeatures.forEach { settingFeature in
            switch settingFeature.name {
            case "multiSession":
                setupMultiSession()
            case "console":
                settings.append(.console)
            case "importExport":
                settings.append(.importUser)
                settings.append(.exportUser)
            case "reset":
                settings.append(.reset)
            case "auth":
                settings.append(.auth)
            default:
                break
            }
        }
        
        settings.append(.setup)
    }
    
    override func setupUI() {
        super.setupUI()
        updateHeight(contentHeight: CGFloat(settings.count * Int(SettingCell.height)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }
    
    private func setupMultiSession() {
        if let rootSessionFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "rootSession" }) {
            if let sessionsCount = (rootSessionFeature.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
                settings.append(.addSession)
            }
        } else if let sessionsCount = (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
            settings.append(.addSession)
        }
        if feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" }) != nil {
            settings.append(.dropSession)
        }
    }
}

extension SettingsScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settings[indexPath.row] {
        case .addSession:
            if let rootSessionFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "rootSession" }) {
                (rootSessionFeature.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.addSession()
            }
            (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.addSession()
            onClose()
        case .dropSession:
            (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.viewController as? SessionViewController)?.dropSession()
            onClose()
        case .console:
            break
        case .setup:
            guard let feature = feature else { return }
            let settingsSetupFeature = Feature(name: "settingsSetup", dependencies: [feature])
            let settingsSetupScreenViewController = SettingsSetupScreenViewController(core: core, feature: settingsSetupFeature)
            navigationController?.pushViewController(settingsSetupScreenViewController, animated: false)
        default:
            break
        }
    }
}

extension SettingsScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell {
            cell.configure(setting: settings[indexPath.row])
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
    
    func configure(setting: Setting) {
        toggleAdditionButton.isHidden = true
        toggleEnablingButton.isHidden = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        titleLabel.text = setting.title.localized(tableName: "Settings")
        switch setting {
        case .setup:
            arrowLabel.isHidden = false
        default:
            arrowLabel.isHidden = true
        }
    }
}

enum Setting: String, CaseIterable {
    
    case addSession
    case dropSession
    case console
    case importUser
    case exportUser
    case reset
    case auth
    case setup
    
    var title: String {
        switch self {
        case .addSession:
            return "Add Session"
        case .dropSession:
            return "Drop Session"
        case .setup:
            return "Setup"
        case .console:
            return "Console"
        case .importUser:
            return "Import"
        case .exportUser:
            return "Export"
        case .reset:
            return "Reset"
        case .auth:
            return "Auth"
        }
    }
}
