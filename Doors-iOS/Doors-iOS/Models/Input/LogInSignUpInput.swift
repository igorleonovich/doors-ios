//
//  SignUpResponse.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 FT. All rights reserved.
//

import Foundation

struct LogInSignUpInput: Codable {
    let user: User
    let refreshToken: String
    let accessToken: String
}
