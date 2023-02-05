//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.09.20.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class ConsoleViewController: BaseSystemFeatureViewController {

    private var isInitialSetupPerformed = false
    static var height = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if !isInitialSetupPerformed {
//            ((feature?.dependencies.first(where: { $0.name == "session" })?.viewController as? BaseSystemFeatureViewController)?.feature?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllersUpdateActions.append { [weak self] isMoreThanOneSessionViewController in
//                guard let self = self else { return }
//                self.view.superview?.snp.updateConstraints({ make in
//                    make.height.equalTo(isMoreThanOneSessionViewController ? self.height : 0)
//                })
//                if let otherFeatureSuperView = self.feature?.dependencies.first(where: { ["sessions", "main"].contains($0.name) })?.viewController?.view.superview {
//                    otherFeatureSuperView.snp.updateConstraints { make in
//                        make.bottom.equalToSuperview().offset(isMoreThanOneSessionViewController ? -self.height : 0)
//                    }
//                }
//            }
//            isInitialSetupPerformed = true
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialSetupPerformed {
            setupHeightRefreshing()
            isInitialSetupPerformed = true
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        var height = 0
        view.superview?.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            if let count = ((feature?.dependencies.first(where: { $0.name == "session" })?.viewController as? BaseSystemFeatureViewController)?.feature?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllers.count, count > 0 {
                height = ConsoleViewController.height
            } else {
                if feature?.dependencies.first(where: { $0.name == "rootSession" }) == nil {
                    height = 0
                } else {
                    height = ConsoleViewController.height
                }
            }
            make.height.equalTo(height)
        }
        
        if let otherFeatureSuperView = feature?.dependencies.first(where: { ["sessions", "main"].contains($0.name) })?.viewController?.view.superview {
            otherFeatureSuperView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-height)
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBorders()
        view.backgroundColor = UIColor.random()
    }
    
    private func setupBorders() {
        view.addBorders(color: Color.foregroundActive, width: 1, sides: [.up])
    }
    
    private func setupHeightRefreshing() {
        ((feature?.dependencies.first(where: { $0.name == "session" })?.viewController as? BaseSystemFeatureViewController)?.feature?.dependencies.first(where: { $0.name == "sessions" })?.viewController as? SessionsViewController)?.sessionViewControllersUpdateActions.append { [weak self] isMoreThanOneSessionViewController in
            guard let self = self else { return }
            var height = 0
            height = isMoreThanOneSessionViewController ? ConsoleViewController.height : 0
            self.view.superview?.snp.updateConstraints({ make in
                make.height.equalTo(height)
            })
            if let otherFeatureSuperView = self.feature?.dependencies.first(where: { ["main"].contains($0.name) })?.viewController?.view.superview {
                otherFeatureSuperView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-height)
                }
            }
        }
    }
}
