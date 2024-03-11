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
    var rootDomain: Domain
}

struct RootSessionConfiguration: Codable {
    
    var sessionConfigurations: [SessionConfiguration]
}

struct SessionConfiguration: Codable {
    
    var id: String = UUID.new
    var domainId: String
    var path: String = "/"
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

struct UserFeature: Codable {
    
    let name: String
    let title: String?
    let dependencies: [UserFeature]?
    let childFeatures: [UserFeature]?
    var accessGroup: AccessGroup! = .free
    var isAdded = false
    var isEnabled = false
    
    var simple: UserFeature {
        return UserFeature(name: name, title: nil, dependencies: dependencies, childFeatures: childFeatures, isEnabled: isEnabled)
    }
}

enum AccessGroup: String, Codable {
    
    case free
    case premium
}

struct Domain: Codable {
    
    var id: String = UUID.new
    var name = Domain.defaultDomainName
    var childDomains = [Domain]()
    var featureMap: FeatureMap
    
    static let defaultDomainName = "Guest"
}
