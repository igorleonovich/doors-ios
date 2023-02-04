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
    var sessionViewControllersUpdateAction: ((Bool) -> Void)? = nil {
        didSet {
            sessionViewControllersUpdateAction?(isMoreThanOneSessionViewController)
        }
    }
    var isMoreThanOneSessionViewController: Bool {
        return sessionViewControllers.count > 1
    }
    private var verticalStackView: UIStackView!
    
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
        verticalStackView = UIStackView()
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        if let feature = feature {
            let sessionFeature = Feature(name: "session", dependencies: [feature])
            loadFeature(sessionFeature)
            let sessionFeature2 = Feature(name: "session", dependencies: [feature])
            loadFeature(sessionFeature2)
            let sessionFeature3 = Feature(name: "session", dependencies: [feature])
            loadFeature(sessionFeature3)
        }
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "session" {
            let sessionView = UIView()
            addSessionView(sessionView)
            let sessionViewController = SessionViewController(core: core, feature: feature)
            feature.viewController = sessionViewController
            add(child: sessionViewController, containerView: sessionView)
            self.sessionViewControllers.append(sessionViewController)
        }
    }
    
    private func addSessionView(_ sessionView: UIView) {
        if let count = (verticalStackView.arrangedSubviews.last as? UIStackView)?.arrangedSubviews.count, count % 2 != 0 {
            (verticalStackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(sessionView)
        } else {
            let horizontalStackView = UIStackView()
            verticalStackView.addArrangedSubview(horizontalStackView)
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.addArrangedSubview(sessionView)
        }
    }
}
