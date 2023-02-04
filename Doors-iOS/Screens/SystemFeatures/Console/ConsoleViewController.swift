//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.09.20.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class ConsoleViewController: BaseSystemFeatureViewController {

    private var height = 50
    
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
        if let otherFeatureSuperView = feature?.dependencies.first(where: { ["sessions", "main"].contains($0.name) })?.viewController?.view.superview {
            otherFeatureSuperView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-height)
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBorders()
        view.backgroundColor = .darkGray
    }
    
    private func setupBorders() {
        view.addBorder(color: Color.foregroundActive, width: 1, sides: [.up])
    }
}
