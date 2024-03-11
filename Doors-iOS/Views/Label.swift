//
//  Label.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.3
        textColor = Color.foregroundActive
    }
}
