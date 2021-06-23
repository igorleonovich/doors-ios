//
//  User.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 FT. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: UUID
    let username: String
    let email: String
    let role: String
    let isEmailVerified: Bool
    let isPhoneVerified: Bool
}
