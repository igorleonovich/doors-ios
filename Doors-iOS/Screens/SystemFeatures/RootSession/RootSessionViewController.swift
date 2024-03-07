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
    
    // MARK: Setup
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        if let feature = feature {
            let userFeature = Feature(name: "user", dependencies: [feature])
            let systemControlsFeature = Feature(name: "systemControls", dependencies: [feature])
            let sessionsFeature = Feature(name: "sessions", dependencies: [feature, systemControlsFeature])
            let importFeature = Feature(name: "import", dependencies: [feature])
            let exportFeature = Feature(name: "export", dependencies: [feature])
            [userFeature, systemControlsFeature, sessionsFeature, importFeature, exportFeature].forEach({ loadChildFeature($0) })
            (userFeature.viewController as? UserViewController)?.user.rootSessionConfiguration.features.forEach { feature in
                if feature.name == "console", let consoleFeature = makeChildFeature(name: "console") {
                    loadChildFeature(consoleFeature)
                }
            }
        }
    }
    
    override func loadChildFeature(_ feature: Feature) {
        super.loadChildFeature(feature)
        if feature.name == "user" {
            let userViewController = UserViewController(core: core, feature: feature)
            feature.viewController = userViewController
            userViewController.run()
        } else if feature.name == "sessions" {
            let sessionsView = UIView()
            view.addSubview(sessionsView)
            sessionsView.snap()
            let sessionsViewController = SessionsViewController(core: core, feature: feature)
            feature.viewController = sessionsViewController
            add(child: sessionsViewController, containerView: sessionsView)
        } else if feature.name == "import" {
            let importViewController = ImportViewController(core: core, feature: feature)
            feature.viewController = importViewController
        } else if feature.name == "export" {
            let exportViewController = ExportViewController(core: core, feature: feature)
            feature.viewController = exportViewController
        }
    }
    
    func makeChildFeature(name: String) -> Feature? {
        if let feature = feature {
            var dependencies = [Feature]()
            if name == "console", let sessionsFeature = feature.childFeatures.first(where: { $0.name == "sessions" }) {
                dependencies.append(contentsOf: [feature, sessionsFeature])
            } else if ["import", "export"].contains(name) {
                dependencies.append(contentsOf: [feature])
            }
            let childFeature = Feature(name: name, dependencies: dependencies)
            return childFeature
        }
        return nil
    }
}
