//
//  UIColor+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
}
