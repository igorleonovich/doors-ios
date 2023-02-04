//
//  SessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionViewController: BaseSystemFeatureViewController {
    
    private var systemControlsView: UIView?
    private var mainView: UIView?
    private var consoleView: UIView?
    
    override init(core: Core, feature: Feature? = nil) {
        super.init(core: core, feature: feature)
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
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "main" {
            let mainView = UIView()
            self.mainView = mainView
            view.addSubview(mainView)
            let mainViewController = MainViewController(core: core, feature: feature)
            feature.viewController = mainViewController
            add(child: mainViewController, containerView: mainView)
            self.featuresViewControllers.append(mainViewController)
        }
    }
}

extension SessionViewController: Router {
    
}
