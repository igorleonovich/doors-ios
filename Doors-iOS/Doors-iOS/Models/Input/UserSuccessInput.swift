//
//  UserSuccessInput.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 FT. All rights reserved.
//

import Foundation

struct UserPrivateInput: Codable {
    let id: UUID?
    let username: String
    let name: String?
    let email: String
    let isEmailVerified: Bool
    let phone: String?
    let isPhoneVerified: Bool
    let role: String
}
