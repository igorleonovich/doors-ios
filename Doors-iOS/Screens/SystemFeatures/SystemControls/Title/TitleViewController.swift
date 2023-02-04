//
//  TitleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class TitleViewController: BaseSystemFeatureViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.textAlignment = .center
        titleLabel.text = "D O O R S"
    }
}