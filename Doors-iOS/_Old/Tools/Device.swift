//
//  Device.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

struct Device {
    
    static var bottomSafeAreaInsets: CGFloat {

//        let keyWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({ $0.isKeyWindow }).first
        
        let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
        
        return keyWindow?.safeAreaInsets.bottom ?? 0.0
    }
}
