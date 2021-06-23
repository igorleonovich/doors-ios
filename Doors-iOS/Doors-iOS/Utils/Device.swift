//
//  Device.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit

struct Device {
    
    static var bottomSafeAreaInsets: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
    }
}
