//
//  Button.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    var isDisabled: Bool = false {
        didSet {
            refreshAlpha()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var state: UIControl.State {
        get {
            switch super.state {
            case .highlighted:
                alpha = 0.8
            default:
                refreshAlpha()
            }
            return super.state
        }
    }
    
    private func setupUI() {
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
    }
    
    private func refreshAlpha() {
        alpha = isDisabled ? 0.5 : 1
    }
}
