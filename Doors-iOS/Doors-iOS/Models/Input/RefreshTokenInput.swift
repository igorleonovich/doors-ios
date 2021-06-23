//
//  RefreshTokenInput.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import Foundation

struct RefreshTokenInput: Codable {
    let status: String
    let accessToken: String
}
