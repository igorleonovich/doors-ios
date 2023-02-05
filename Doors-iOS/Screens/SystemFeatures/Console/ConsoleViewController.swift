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
    private var height = 50
    
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
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(height)
//            make.height.equalTo(feature?.dependencies.first(where: { $0.name == "rootSession" }) == nil ? height : 0)
        }
        if let otherFeatureSuperView = feature?.dependencies.first(where: { ["sessions", "main"].contains($0.name) })?.viewController?.view.superview {
            otherFeatureSuperView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-height)
//                make.bottom.equalToSuperview().offset(feature?.dependencies.first(where: { $0.name == "rootSession" }) == nil ? 0 : -height)
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBorders()
    }
    
    private func setupBorders() {
        view.addBorders(color: Color.foregroundActive, width: 1, sides: [.up])
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = Color.foregroundActive.cgColor
    }
}
