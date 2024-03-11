//
//  SessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionViewController: BaseSystemFeatureViewController {
    
    private let borderSide: BorderSide?
    private weak var sessionContentView: UIView?
    
    init(core: Core, feature: Feature? = nil, borderSide: BorderSide? = nil) {
        self.borderSide = borderSide
        super.init(core: core, feature: feature)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialFeatures()
    }
    
    // MARK: Setup
    
    private func setupUI() {
        setupBorders()
    }
    
    private func setupBorders() {
        if let borderSide = borderSide {
            let borders = view.addBorders(color: Color.foregroundActive, width: 1, sides: [borderSide])
            borders.first?.snp.updateConstraints({ make in
                make.top.equalToSuperview().offset(SystemControlsViewController.height)
            })
        }
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        if let feature = feature {
            let systemControlsFeature = Feature(name: "systemControls", dependencies: [feature])
            let sessionContentFeature = Feature(name: "sessionContent", dependencies: [systemControlsFeature])
            [systemControlsFeature, sessionContentFeature].forEach({ loadChildFeature($0) })
        }
    }
    
    override func loadChildFeature(_ feature: Feature) {
        super.loadChildFeature(feature)
        if feature.name == "sessionContent" {
            let sessionContentView = UIView()
            self.sessionContentView = sessionContentView
            view.addSubview(sessionContentView)
            let sessionContentViewController = SessionContentViewController(core: core, feature: feature)
            feature.viewController = sessionContentViewController
            add(child: sessionContentViewController, containerView: sessionContentView)
        }
    }
    
    func loadFeature(name: String) {
        if let feature = feature, let mainFeature = feature.childFeatures.first(where: { $0.name == "main" }) {
            let consoleFeature = Feature(name: name, dependencies: [feature, mainFeature])
            loadChildFeature(consoleFeature)
        }
    }
    
    func dropSession() {
        if let index = (parent as? SessionsViewController)?.sessionViewControllers.firstIndex(of: self) {
            (parent as? SessionsViewController)?.sessionViewControllers.remove(at: index)
        }
        if let sessionId = (feature as? SessionFeature)?.sessionId,
           let userViewController = feature?.dependencies.first(where: { $0.name == "sessions" })?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController,
           let sessionConfiguration = userViewController.user.rootSessionConfiguration.sessionConfigurations.first(where: { $0.id == sessionId }),
           let index = userViewController.user.rootSessionConfiguration.sessionConfigurations.firstIndex(of: sessionConfiguration) {
                userViewController.user.rootSessionConfiguration.sessionConfigurations.remove(at: index)
            NotificationCenter.default.post(name: Notification.Name.didUpdateUser, object: nil)
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
