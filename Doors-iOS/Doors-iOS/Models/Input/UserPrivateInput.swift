//
//  UserPrivateInput.swift
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
    let doorsServicesActive: [DoorsService]
    let doorsServicesInactive: [DoorsService]
}


enum Role: String, Codable {
    case empty, guest, use, test, dev, publish, admin
}

enum DoorsService: String, Codable {
    case id, scene, engine, bank, arteka
}
