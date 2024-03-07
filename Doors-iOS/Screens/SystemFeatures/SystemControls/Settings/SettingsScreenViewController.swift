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
        if core.rootCore.appManager.featureMap?.settingsFeatures.first(where: { $0.name == "multiSession" }) != nil {
            setupMultiSession()
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
        case .setup:
            let vc = UIViewController()
            vc.view.backgroundColor = .black
            navigationController?.pushViewController(vc, animated: false)
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
    
    func onToggle(_ index: Int) {
            
    }
}

final class SettingCell: MenuTableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(setting: Setting) {
        toggleButton.isHidden = true
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
    case setup
    
    var title: String {
        switch self {
        case .addSession:
            return "Add Session"
        case .dropSession:
            return "Drop Session"
        case .setup:
            return "Setup"
        }
    }
}
