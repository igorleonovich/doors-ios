//
//  SessionsViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionsViewController: BaseSystemFeatureViewController {

    var sessionViewControllers = [SessionViewController]() {
        didSet {
            sessionViewControllersUpdateActions.forEach { action in
                action?(isMoreThanOneSessionViewController)
            }
        }
    }
    var sessionViewControllersUpdateActions = [((Bool) -> Void)?]()
    var isMoreThanOneSessionViewController: Bool {
        return sessionViewControllers.count > 1
    }
    private var verticalStackView: UIStackView!
    
    // MARK: Constants
    
    private let maxSessions = 6
    
    // MARK: Life Cycle
    
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
        addSession()
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "session" {
            let sessionView = UIView()
            let borderSide = addSessionView(sessionView)
            let sessionViewController = SessionViewController(core: core, feature: feature, borderSide: borderSide)
            feature.viewController = sessionViewController
            add(child: sessionViewController, containerView: sessionView)
            self.sessionViewControllers.append(sessionViewController)
        }
    }
    
    func addSession() {
        if sessionViewControllers.count < maxSessions {
            if let feature = feature {
                let sessionFeature = Feature(name: "session", dependencies: [feature])
                loadFeature(sessionFeature)
            }
        }
    }
    
    private func addSessionView(_ sessionView: UIView) -> BorderSide? {
        if let count = (verticalStackView.arrangedSubviews.last as? UIStackView)?.arrangedSubviews.count, count % 2 != 0 {
            (verticalStackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(sessionView)
            return .left
        } else {
            let horizontalStackView = AutoReducingStackView()
            verticalStackView.addArrangedSubview(horizontalStackView)
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.addArrangedSubview(sessionView)
            return nil
        }
    }
}
