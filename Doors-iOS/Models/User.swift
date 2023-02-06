//
//  User.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let rootSessionConfiguration: RootSessionConfiguration
}

struct RootSessionConfiguration: Codable {
    
    let sessionConfigurations: [SessionConfiguration]
}

struct SessionConfiguration: Codable {
    
    var features = [FeatureModel]()
}

struct FeatureModel: Codable {
    
    let childFeatures: [FeatureModel]
}
