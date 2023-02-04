//
//  MainViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class MainViewController: BaseFeatureViewController {
    
    private var featuresViewControllers = [BaseFeatureViewController]()
    
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
            if let superSuperView = view.superview?.superview {
                make.bottom.equalTo(superSuperView.safeAreaLayoutGuide.snp.bottom).offset(0)
            }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
//        let borderWidth: CGFloat = 1
//        let borderColor = Color.foregroundActive
//        view.addTopBorder(color: borderColor, width: borderWidth)
//        view.addBottomBorder(color: borderColor, width: borderWidth)
        view.backgroundColor = .lightGray
    }
    
    private func loadInitialFeatures() {
        
    }
    
    private func loadFeature(_ feature: Feature) {

    }
}
