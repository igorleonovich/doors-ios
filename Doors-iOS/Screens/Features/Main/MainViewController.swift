//
//  MainViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class MainViewController: BaseFeatureViewController {
    
    private weak var core: Core!
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
        loadInitialFeatures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    private func loadInitialFeatures() {
        let initialFeature = Feature(name: "settings", dependencies: [])
        loadFeature(initialFeature)
    }
    
    private func loadFeature(_ feature: Feature) {

    }
}
