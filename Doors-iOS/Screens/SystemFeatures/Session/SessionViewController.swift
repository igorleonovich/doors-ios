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
        if let feature = feature {
            let systemControlsFeature = Feature(name: "systemControls", dependencies: [feature])
            let mainFeature = Feature(name: "main", dependencies: [systemControlsFeature])
            let consoleFeature = Feature(name: "console", dependencies: [feature, mainFeature])
            [systemControlsFeature, mainFeature, consoleFeature].forEach({ loadFeature($0) })
        }
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
        }
        childFeatures.append(feature)
    }
    
    func dropSession() {
        if let index = (parent as? SessionsViewController)?.sessionViewControllers.firstIndex(of: self) {
            (parent as? SessionsViewController)?.sessionViewControllers.remove(at: index)
        }
        onClose()
    }
    
    @objc private func onClose() {
        if let superview = view.superview {
            (superview.superview as? UIStackView)?.removeArrangedSubview(superview)
        }
        remove()
    }
}

extension SessionViewController: Router {
    
}
