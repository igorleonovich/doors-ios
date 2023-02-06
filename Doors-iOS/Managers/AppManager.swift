//
//  AppManager.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

final class AppManager {
    
    var isUserInitiallyLoaded: Bool {
        get {
            return Defaults.store?.bool(forKey: AppKeys.isUserInitiallyLoaded.rawValue) ?? false
        }
        set { Defaults.set(newValue, forKey: AppKeys.isUserInitiallyLoaded.rawValue) }
    }
}
