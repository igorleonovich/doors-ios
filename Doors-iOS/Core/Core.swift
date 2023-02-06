//
//  Core.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation

final class RootCore {
    
    lazy var fileSystemManager: FileSystemManager = {
       return FileSystemManager()
    }()
    lazy var appManager: AppManager = {
        return AppManager()
    }()
}

final class Core {

    weak var rootCore: RootCore!
    weak var router: Router!
}
