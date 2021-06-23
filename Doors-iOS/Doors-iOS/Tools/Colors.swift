//
//  Colors.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/17/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var customAccent: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .white
        }
    }
}
