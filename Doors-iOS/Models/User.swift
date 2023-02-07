//
//  User.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var rootSessionConfiguration: RootSessionConfiguration
}

struct RootSessionConfiguration: Codable {
    
    var sessionConfigurations: [SessionConfiguration]
    var features = [FeatureModel]()
}

struct SessionConfiguration: Codable {
    
    var id: String
    var features = [FeatureModel]()
}

extension SessionConfiguration: Equatable {
    
    static func == (lhs: SessionConfiguration, rhs: SessionConfiguration) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SessionConfiguration: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FeatureModel: Codable {
    
    let name: String
    let title: String?
    let childFeatures: [FeatureModel]?
    
    var simple: FeatureModel {
        return FeatureModel(name: self.name, title: nil, childFeatures: childFeatures)
    }
}
