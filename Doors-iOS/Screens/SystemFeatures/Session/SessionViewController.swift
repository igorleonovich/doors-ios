//
//  SessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionViewController: BaseSystemFeatureViewController {

    private weak var core: Core!
    private var featuresViewControllers = [BaseFeatureViewController]()
    
    init(core: Core) {
        self.core = core
        super.init()
        core.router = self
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
        
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        let systemControlsFeature = Feature(name: "systemControls", dependencies: [])
        loadFeature(systemControlsFeature)
//        let mainFeature = Feature(name: "main", dependencies: [])
//        [systemControlsFeature, mainFeature].forEach({ loadFeature($0) })
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "systemControls" {
            let systemControlsView = UIView()
            view.addSubview(systemControlsView)
            systemControlsView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.height.equalTo(50)
            }
            let systemControlsViewController = SystemControlsViewController(core: core)
            add(child: systemControlsViewController, containerView: systemControlsView)
            self.featuresViewControllers.append(systemControlsViewController)
        } else if feature.name == "main" {
            let mainViewController = MainViewController(core: core)
            add(child: mainViewController)
            view.addSubview(mainViewController.view)
            self.featuresViewControllers.append(mainViewController)
        }
//        else if feature.name == "console" {
//           let consoleViewController = ConsoleViewController(core: core)
//           add(child: consoleViewController)
//           view.addSubview(consoleViewController.view)
//           self.featuresViewControllers.append(consoleViewController)
//       }
    }
}

extension SessionViewController: Router {
    
}
