//
//  BaseViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseFeatureViewController: BaseViewController {
    
    var core: Core!
    var feature: Feature?

    init(core: Core, feature: Feature? = nil) {
        self.core = core
        self.feature = feature
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseSystemFeatureViewController: BaseFeatureViewController {
    
    func loadFeature(_ feature: Feature) {
        if feature.name == "systemControls" {
            let systemControlsView = UIView()
            view.addSubview(systemControlsView)
            let systemControlsViewController = SystemControlsViewController(core: core, feature: feature)
            feature.viewController = systemControlsViewController
            add(child: systemControlsViewController, containerView: systemControlsView)
        } else if feature.name == "console" {
            let consoleView = UIView()
            view.addSubview(consoleView)
            let consoleViewController = ConsoleViewController(core: core, feature: feature)
            feature.viewController = consoleViewController
            add(child: consoleViewController, containerView: consoleView)
        }
        self.feature?.childFeatures.append(feature)
    }
    
    func unloadFeature(name: String) {
        if name == "console" {
            feature?.childFeatures.first(where: { $0.name == "console" })?.viewController?.remove()
            if let indexToRemove = feature?.childFeatures.firstIndex(where: { $0.name == "console" }) {
                feature?.childFeatures.remove(at: indexToRemove)
            }
        }
    }
}

class BaseSystemFeatureMenuViewController: BaseSystemFeatureViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupGesture()
    }
    
    // MARK: - Setup
    
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        tableView = TableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.height.equalTo((Setting.allCases.count * Int(SettingCell.height)))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        tableView.bounces = false
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func setupData() {}
    
    
    // MARK: Actions
    
    @objc private func onTap() {
        onClose()
    }
    
    func onClose(_ completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}

extension BaseSystemFeatureMenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !tableView.point(inside: touch.location(in: tableView), with: nil)
    }
}
