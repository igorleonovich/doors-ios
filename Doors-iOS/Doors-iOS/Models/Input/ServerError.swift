//
//  ServerError.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/11/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import Foundation

struct ServerError: Codable {
    let error: Bool
    let reason: String
}
