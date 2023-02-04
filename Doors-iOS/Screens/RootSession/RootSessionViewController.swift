//
//  RootSessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class RootSessionViewController: BaseViewController {

    private var core: Core!
    private var sessionViewControllers = [SessionViewController]()
    
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
        
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        let sessionsFeature = Feature(name: "sessions", dependencies: [])
        loadFeature(sessionsFeature)
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "sessions" {
            loadDefaultSession()
            func loadDefaultSession() {
                let sessionFeature = Feature(name: "session", dependencies: [])
                loadFeature(sessionFeature)
            }
        } else if feature.name == "session" {
            let sessionViewController = SessionViewController(core: core)
            add(child: sessionViewController)
            view.addSubview(sessionViewController.view)
            self.sessionViewControllers.append(sessionViewController)
        }
    }
}
