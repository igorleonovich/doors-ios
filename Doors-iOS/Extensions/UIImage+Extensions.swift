//
//  UIImage+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 06/03/2024.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension UIImage {
    
    var withForegroundActiveColor: UIImage {
        withRenderingMode(.alwaysOriginal).withTintColor(Color.foregroundActive)
    }
}

