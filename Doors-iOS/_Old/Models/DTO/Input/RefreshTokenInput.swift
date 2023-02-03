//
//  RefreshTokenInput.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation

struct RefreshTokenInput: Codable {
    let status: String
    let accessToken: String
}
