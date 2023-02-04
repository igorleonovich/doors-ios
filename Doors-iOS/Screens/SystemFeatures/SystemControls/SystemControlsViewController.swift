//
//  SystemControlsViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SystemControlsViewController: BaseSystemFeatureViewController {
    
    private var stackView: UIStackView!
    private var isInitialSetupPerformed = false
    private let height = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialFeatures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialSetupPerformed {
            ((feature?.dependencies.first(where: { $0.name == "rootSession" })?.viewController as? BaseSystemFeatureViewController)?.featuresViewControllers.first(where: { $0.isKind(of: SessionsViewController.self) }) as? SessionsViewController)?.sessionViewControllersUpdateAction = { [weak self] isMoreThanOneSessionViewController in
                guard let self = self else { return }
                    self.view.superview?.snp.updateConstraints({ make in
                        make.height.equalTo(isMoreThanOneSessionViewController ? self.height : 0)
                    })
            }
            isInitialSetupPerformed = true
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.remakeConstraints { make in
            if let superSuperView = view.superview?.superview {
                make.top.equalTo(superSuperView.safeAreaLayoutGuide.snp.top)
            }
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(feature?.dependencies.first(where: { $0.name == "rootSession" }) == nil ? 0 : height)
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        stackView = UIStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
    }
    
    // MARK: Actions
    
    private func loadInitialFeatures() {
        let startFeature = Feature(name: "start", dependencies: [])
        let titleFeature = Feature(name: "title", dependencies: [])
        let settingsFeature = Feature(name: "settings", dependencies: [])
        [startFeature, titleFeature, settingsFeature].forEach({ loadFeature($0) })
    }
    
    override func loadFeature(_ feature: Feature) {
        if feature.name == "start" {
            let startView = UIView()
            stackView.addArrangedSubview(startView)
            let startViewController = StartViewController(core: core)
            add(child: startViewController, containerView: startView)
            self.featuresViewControllers.append(startViewController)
        } else if feature.name == "title" {
            let titleView = UIView()
            stackView.addArrangedSubview(titleView)
            let titleViewController = TitleViewController(core: core)
            add(child: titleViewController, containerView: titleView)
            self.featuresViewControllers.append(titleViewController)
        } else if feature.name == "settings" {
            let settingsView = UIView()
            stackView.addArrangedSubview(settingsView)
            let settingsViewController = SettingsViewController(core: core)
            add(child: settingsViewController, containerView: settingsView)
            self.featuresViewControllers.append(settingsViewController)
        }
    }
}
