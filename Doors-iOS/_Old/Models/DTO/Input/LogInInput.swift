//
//  LogInInput.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation

struct LogInInput: Codable {
    let user: UserPrivateInput
    let refreshToken: String
    let accessToken: String
}
