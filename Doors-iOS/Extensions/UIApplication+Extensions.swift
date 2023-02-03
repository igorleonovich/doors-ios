//
//  UIApplication+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension UIApplication {

    static var rootViewController: RootViewController? {
        return ((UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController as? RootViewController)
    }
}
