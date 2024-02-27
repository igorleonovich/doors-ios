//
//  CustomButton.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 26.07.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cornerRadius = OldConstants.Skin.buttonCornerRadius
    }
}
