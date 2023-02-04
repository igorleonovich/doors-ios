//
//  MainViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class MainViewController: BaseFeatureViewController {
    
    weak var core: Core!
    private var featuresViewControllers = [BaseFeatureViewController]()
    
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
        run()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    private func run() {
        loadInitialFeature()
    }
    
    private func loadInitialFeature() {
        let initialFeature = Feature(name: "settings", dependencies: [])
        loadFeature(initialFeature)
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "settings" {
            let settingsView = UIView()
            view.addSubview(settingsView)
            settingsView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.right.equalTo(20)
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
            let settingsViewController = SettingsViewController(core: core)
            add(child: settingsViewController)
            view.addSubview(settingsViewController.view)
            self.featuresViewControllers.append(settingsViewController)
        } else if feature.name == "console" {
            let consoleViewController = ConsoleViewController(core: core)
            add(child: consoleViewController)
            view.addSubview(consoleViewController.view)
            self.featuresViewControllers.append(consoleViewController)
        }
    }
}
