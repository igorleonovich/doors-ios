//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.09.20.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class ConsoleViewController: BaseSystemFeatureViewController {

    private var height = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(height)
        }
        if let mainSuperView = feature?.dependencies.first(where: { $0.name == "main" })?.viewController?.view.superview {
            mainSuperView.snp.updateConstraints { make in
                if let mainSuperSuperview = mainSuperView.superview {
                    make.bottom.equalTo(mainSuperSuperview.safeAreaLayoutGuide.snp.bottom).offset(-height)
                }
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {

    }
}
