//
//  UIScreen+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 10.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static var isScreenSmall: Bool {
        return UIScreen.main.bounds.height < 800
    }
}
