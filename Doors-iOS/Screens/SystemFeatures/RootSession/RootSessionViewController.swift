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
            let userFeature = Feature(name: "user", dependencies: [feature])
            let systemControlsFeature = Feature(name: "systemControls", dependencies: [feature])
            let sessionsFeature = Feature(name: "sessions", dependencies: [feature, systemControlsFeature])
            [userFeature, systemControlsFeature, sessionsFeature].forEach({ loadFeature($0) })
            (userFeature.viewController as? UserViewController)?.user.rootSessionConfiguration.features.forEach { feature in
                if feature.name == "console" {
                    loadFeature(name: "console")
                }
            }
        }
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "user" {
            let userViewController = UserViewController(core: core, feature: feature)
            feature.viewController = userViewController
            userViewController.run()
        } else if feature.name == "sessions" {
            let sessionsView = UIView()
            view.addSubview(sessionsView)
            let sessionsViewController = SessionsViewController(core: core, feature: feature)
            feature.viewController = sessionsViewController
            add(child: sessionsViewController, containerView: sessionsView)
        } else if feature.name == "export" {
            let exportViewController = ExportViewController(core: core, feature: feature)
            feature.viewController = exportViewController
            exportViewController.run()
        } else if feature.name == "import" {
            let importViewController = ImportViewController(core: core, feature: feature)
            feature.viewController = importViewController
            importViewController.run()
        }
    }
    
    func loadFeature(name: String) -> Feature? {
        if let feature = feature {
            var dependencies = [Feature]()
            if name == "console", let sessionsFeature = feature.childFeatures.first(where: { $0.name == "sessions" }) {
                dependencies.append(contentsOf: [feature, sessionsFeature])
            } else if ["export", "import"].contains(name) {
                dependencies.append(contentsOf: [feature])
            }
            let feature = Feature(name: name, dependencies: dependencies)
            loadFeature(feature)
            return feature
        }
        return nil
    }
}
