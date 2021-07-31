//
//  PointDTO.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 26.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import Foundation

struct PointDTO: Codable {
    let id: UUID?
    let userID: UUID
    let superPointID: UUID?
    let blockID: UUID?
    let index: Int
    let text: String
}
