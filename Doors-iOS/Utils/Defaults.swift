//
//  Defaults.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

struct Defaults {
    
    static let store = UserDefaults(suiteName: "\(Bundle.main.object(forInfoDictionaryKey: "PRODUCT_BUNDLE_IDENTIFIER") ?? "").store")
    
    static func set(_ value: Any?, forKey: String) {
        store?.set(value, forKey: forKey)
        store?.synchronize()
    }
}

enum AppKeys: String {
    
    case isUserInitiallyLoaded
}
