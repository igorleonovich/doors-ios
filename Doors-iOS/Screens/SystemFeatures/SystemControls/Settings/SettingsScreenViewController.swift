//
//  SettingsScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsScreenViewController: BaseViewController {

    private weak var core: Core!
    private var tableView: UITableView!
    
    init(core: Core) {
        self.core = core
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        tableView = UITableView()
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
        tableView.backgroundColor = .clear
        tableView.bounces = false
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func onTap() {
        dismiss(animated: true)
    }
}

extension SettingsScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Setting.allCases[indexPath.row]
    }
}

extension SettingsScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell {
            cell.configure(setting: Setting.allCases[indexPath.row])
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
        textLabel?.text = setting.title
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
