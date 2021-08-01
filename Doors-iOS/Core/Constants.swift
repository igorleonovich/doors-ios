//
//  Constants.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit

struct Constants {
    static let baseURL = "https://dev.api.doorsid-com.recolourmusic.com"
//        static let baseURL = "https://stage.api.doorsid-com.recolourmusic.com"
//    static let baseURL = "https://api.doorsid.com"
    
    struct Skin {
        static let buttonCornerRadius: CGFloat = 5.0
        static let fontSize: CGFloat = 18.0
        static let font: UIFont = UIFont.systemFont(ofSize: Constants.Skin.fontSize, weight: .ultraLight)
    }
}
