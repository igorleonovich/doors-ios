//
//  SettingsScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsScreenViewController: BaseSystemFeatureViewController {

    private var tableView: UITableView!
    private var settings = [Setting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupGesture()
    }
    
    // MARK: - Setup
    
    private func setupData() {
        
        if let rootSessionFeature = feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "rootSession" }) {
            if let sessionsCount = (rootSessionFeature.viewController?.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
                settings.append(.addSession)
            }
        } else if let sessionsCount = (feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" })?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, sessionsCount < SessionsViewController.maxSessions {
            settings.append(.addSession)
        }
        if feature?.dependencies.first(where: { $0.name == "settings" })?.dependencies.first(where: { $0.name == "systemControls" })?.dependencies.first(where: { $0.name == "session" }) != nil {
            settings.append(.dropSession)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        tableView = TableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.height.equalTo((Setting.allCases.count * Int(SettingCell.height)))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.bounces = false
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: Actions
    
    @objc private func onTap() {
        onClose()
    }
    
    private func onClose() {
        dismiss(animated: true)
    }
}

extension SettingsScreenViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !tableView.point(inside: touch.location(in: tableView), with: nil)
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
                (rootSessionFeature.viewController?.childFeatures.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.addSession()
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

final class SettingCell: TableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(setting: Setting) {
        textLabel?.textAlignment = .center
        textLabel?.textColor = .white
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        textLabel?.text = setting.title.localized
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
