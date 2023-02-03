//
//  Core.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation

class OldCore {
    
    let authManager = AuthManager()
    let userManager = UserManager()
    
    var sceneManager: SceneManager?
    
    lazy var signedSessionConfiguration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return config
    }()
    
    init() {
        authManager.core = self
        userManager.core = self
    }
}
