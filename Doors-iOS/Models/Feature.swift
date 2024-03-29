//
//  Feature.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

class Feature: NSObject {
    
    let name: String
    let dependencies: [Feature]
    var childFeatures = [Feature]()
    var viewController: BaseFeatureViewController?
    
    init(name: String, dependencies: [Feature] = [Feature]()) {
        self.name = name
        self.dependencies = dependencies
        super.init()
    }
}
