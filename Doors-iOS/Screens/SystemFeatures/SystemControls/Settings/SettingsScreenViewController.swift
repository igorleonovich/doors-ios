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
    
    override func setupUI() {
        super.setupUI()
        updateHeight(contentHeight: CGFloat(settings.count * Int(SettingCell.height)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
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
        case .dropSession:
            (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.viewController as? SessionViewController)?.dropSession()
        }
        onClose()
    }
}

extension SettingsScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell {
            cell.configure(setting: settings[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

final class SettingCell: BaseTableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(setting: Setting) {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        titleLabel.text = setting.title.localized(tableName: "Settings")
    }
}

enum Setting: String, CaseIterable {
    
    case addSession
    case dropSession
    
    var title: String {
        switch self {
        case .addSession:
            return "Add Session"
        case .dropSession:
            return "Drop Session"
        }
    }
}
