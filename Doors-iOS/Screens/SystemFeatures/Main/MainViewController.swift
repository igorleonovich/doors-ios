//
//  MainViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class MainViewController: BaseSystemFeatureViewController {
    
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
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBorders()
        view.backgroundColor = .random().withAlphaComponent(0.5)
    }
    
    private func setupBorders() {
        view.addBorders(color: Color.foregroundActive, width: 1, sides: [.up])
    }
    
    private func loadInitialFeatures() {
        
    }
    
    override func loadFeature(_ feature: Feature) {
        
    }
}
