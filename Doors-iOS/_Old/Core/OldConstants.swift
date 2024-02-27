//
//  Constants.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

struct OldConstants {
    
    static let baseURL: String = Bundle.main.object(forInfoDictionaryKey: "DOORS_API_BASE_URL") as? String ?? ""
    
    struct Skin {
        static let buttonCornerRadius: CGFloat = 5.0
        static let fontSize: CGFloat = 18.0
        static let font: UIFont = UIFont.systemFont(ofSize: OldConstants.Skin.fontSize, weight: .ultraLight)
    }
}
