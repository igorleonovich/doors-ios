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
    
    private var systemControlsView: UIView?
    private var mainView: UIView?
    private var consoleView: UIView?
    
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
        let mainFeature = Feature(name: "main", dependencies: [systemControlsFeature])
        let consoleFeature = Feature(name: "console", dependencies: [mainFeature])
        [systemControlsFeature, mainFeature, consoleFeature].forEach({ loadFeature($0) })
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "systemControls" {
            let systemControlsView = UIView()
            self.systemControlsView = systemControlsView
            view.addSubview(systemControlsView)
            let systemControlsViewController = SystemControlsViewController(core: core)
            feature.viewController = systemControlsViewController
            add(child: systemControlsViewController, containerView: systemControlsView)
            self.featuresViewControllers.append(systemControlsViewController)
        } else if feature.name == "main" {
            let mainView = UIView()
            self.mainView = mainView
            view.addSubview(mainView)
            let mainViewController = MainViewController(core: core, feature: feature)
            feature.viewController = mainViewController
            add(child: mainViewController, containerView: mainView)
            self.featuresViewControllers.append(mainViewController)
        } else if feature.name == "console" {
            let consoleView = UIView()
            self.consoleView = consoleView
            view.addSubview(consoleView)
            let consoleViewController = ConsoleViewController(core: core, feature: feature)
            add(child: consoleViewController, containerView: consoleView)
            self.featuresViewControllers.append(consoleViewController)
       }
    }
}

extension SessionViewController: Router {
    
}
