//
//  SystemControlsViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SystemControlsViewController: BaseSystemFeatureViewController {

    private weak var core: Core!
    private var featuresViewControllers = [BaseSystemFeatureViewController]()
    
    private var stackView: UIStackView!
    
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
        loadInitialFeatures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        stackView = UIStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        let startFeature = Feature(name: "start", dependencies: [])
        let titleFeature = Feature(name: "title", dependencies: [])
        let settingsFeature = Feature(name: "settings", dependencies: [])
        [startFeature, titleFeature, settingsFeature].forEach({ loadFeature($0) })
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "start" {
            let startView = UIView()
            startView.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            stackView.addArrangedSubview(startView)
            let startViewController = StartViewController(core: core)
            add(child: startViewController, containerView: startView)
            self.featuresViewControllers.append(startViewController)
        } else if feature.name == "title" {
            let titleView = UIView()
            stackView.addArrangedSubview(titleView)
            let titleViewController = TitleViewController(core: core)
            add(child: titleViewController, containerView: titleView)
            self.featuresViewControllers.append(titleViewController)
        } else if feature.name == "settings" {
            let settingsView = UIView()
            settingsView.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            stackView.addArrangedSubview(settingsView)
            let settingsViewController = SettingsViewController(core: core)
            add(child: settingsViewController, containerView: settingsView)
            self.featuresViewControllers.append(settingsViewController)
        }
//        else if feature.name == "console" {
//            let consoleView = UIView()
//            stackView.addArrangedSubview(consoleView)
//            let consoleViewController = ConsoleViewController(core: core)
//            add(child: consoleViewController, containerView: consoleView)
//            self.featuresViewControllers.append(consoleViewController)
//        }
    }
}
