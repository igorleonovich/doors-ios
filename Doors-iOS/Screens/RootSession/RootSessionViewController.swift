//
//  RootSessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class RootSessionViewController: BaseSystemFeatureViewController {
    
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
        if let feature = feature {
            let systemControlsFeature = Feature(name: "systemControls", dependencies: [feature])
            let sessionsFeature = Feature(name: "sessions", dependencies: [systemControlsFeature])
//            let consoleFeature = Feature(name: "console", dependencies: [sessionsFeature])
            [systemControlsFeature, sessionsFeature].forEach({ loadFeature($0) })
        }
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "sessions" {
            let sessionsView = UIView()
            view.addSubview(sessionsView)
            let sessionsViewController = SessionsViewController(core: core, feature: feature)
            feature.viewController = sessionsViewController
            add(child: sessionsViewController, containerView: sessionsView)
        }
        childFeatures.append(feature)
    }
}
