//
//  SessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionViewController: BaseViewController {

    weak var core: Core!
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
        loadInitialFeature()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    private func loadInitialFeature() {
        let mainFeature = Feature(name: "main", dependencies: [])
        loadFeature(mainFeature)
    }
    
    private func loadFeature(_ feature: Feature) {
        if feature.name == "main" {
            let mainViewController = MainViewController(core: core)
            add(child: mainViewController)
            view.addSubview(mainViewController.view)
            self.featuresViewControllers.append(mainViewController)
        }
    }
}

extension SessionViewController: Router {
    
}

protocol Router: AnyObject {
    
}
