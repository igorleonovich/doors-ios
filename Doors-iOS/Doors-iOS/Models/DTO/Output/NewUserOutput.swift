//
//  NewUser.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 FT. All rights reserved.
//

import Foundation

struct NewUserOutput: Codable {
    let username: String
    let email: String
    let password: String
    let confirmPassword: String
}
