//
//  SignUpResponse.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import Foundation

struct LogInSignUpInput: Codable {
    let status: String
    let user: User
    let refreshToken: String
    let accessToken: String
}
