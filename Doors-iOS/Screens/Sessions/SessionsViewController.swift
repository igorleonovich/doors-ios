//
//  SessionsViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionsViewController: BaseSystemFeatureViewController {

    private var sessionViewControllers = [SessionViewController]() {
        didSet {
            sessionViewControllersUpdateAction?(isMoreThanOneSessionViewController)
        }
    }
    var sessionViewControllersUpdateAction: ((Bool) -> Void)? = nil
    var isMoreThanOneSessionViewController: Bool {
        return sessionViewControllers.count > 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialFeatures()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.remakeConstraints { make in
            if let systemControlsSuperView = feature?.dependencies.first(where: { $0.name == "systemControls" })?.viewController?.view.superview {
                make.top.equalTo(systemControlsSuperView.safeAreaLayoutGuide.snp.bottom)
            }
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        let sessionFeature = Feature(name: "session", dependencies: [])
        loadFeature(sessionFeature)
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "session" {
            let sessionViewController = SessionViewController(core: core)
            add(child: sessionViewController)
            view.addSubview(sessionViewController.view)
            self.sessionViewControllers.append(sessionViewController)
        }
    }
}
