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
    var isNoOneSessionViewController: Bool {
        return sessionViewControllers.count <= 0
    }
    var isMoreThanOneSessionViewController: Bool {
        return sessionViewControllers.count > 1
    }
    private var verticalStackView: UIStackView!
    
    // MARK: Constants
    
    static let maxSessions = 6
    
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
        if let sessionIds = (feature?.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController)?.user.rootSessionConfiguration.sessionConfigurations.map({ $0.id }) {
            sessionIds.forEach { sessionId in
                addSession(sessionId: sessionId)
            }
        }
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "session" {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let sessionView = UIView()
                let borderSide = self.addSessionView(sessionView)
                let core = Core()
                core.rootCore = self.core.rootCore
                let sessionViewController = SessionViewController(core: core, feature: feature, borderSide: borderSide)
                feature.viewController = sessionViewController
                self.add(child: sessionViewController, containerView: sessionView)
                self.sessionViewControllers.append(sessionViewController)
            }
        }
    }
    
    func addSession(sessionId: String? = nil, isLoaded: Bool = false) {
        guard let feature = feature else { return }
        if let sessionId = sessionId {
            loadSessionFeature(with: sessionId)
        } else {
            let sessionId = UUID.new
            loadSessionFeature(with: sessionId)
            let sessionConfiguration = SessionConfiguration(id: sessionId)
            (feature.dependencies.first(where: { $0.name == "rootSession" })?.childFeatures.first(where: { $0.name == "user" })?.viewController as? UserViewController)?.user.rootSessionConfiguration.sessionConfigurations.append(sessionConfiguration)
                NotificationCenter.default.post(name: Notification.Name("DidUpdateUser"), object: nil)
        }
        func loadSessionFeature(with sessionId: String) {
            let sessionFeature = SessionFeature(name: "session", dependencies: [feature], sessionId: sessionId)
            loadFeature(sessionFeature)
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

final class SessionFeature: Feature {
    
    let sessionId: String
    
    init(name: String, dependencies: [Feature], sessionId: String) {
        self.sessionId = sessionId
        super.init(name: name, dependencies: dependencies)
    }
}
