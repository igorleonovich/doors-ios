//
//  UserViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class UserViewController: BaseSystemFeatureViewController {
    
    var user: User!
    
    override init(core: Core, feature: Feature? = nil) {
        super.init(core: core, feature: feature)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    
    func run() {
        loadInitialFeatures()
    }
    
    private func loadInitialFeatures() {
        let checkDoorsFolderFeature = Feature(name: "checkDoorsFolder", dependencies: [])
        let setupUserFeature = Feature(name: "setupUser", dependencies: [])
        [checkDoorsFolderFeature, setupUserFeature].forEach({ loadFeature($0) })
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "checkDoorsFolder" {
            let folderName = "Doors"
            if core.rootCore.fileSystemManager.isFileExists(fileName: folderName, fileFormat: "") == false {
                core.rootCore.fileSystemManager.createFolder(folderName: folderName)
            }
            if let path = core.rootCore.fileSystemManager.fileURL(fileName: folderName, fileFormat: "")?.path {
                print("[FILE SYSTEM] Doors path:\n\(path)")
            }
        } else if feature.name == "setupUser" {
            if core.rootCore.fileSystemManager.isFileExists(fileName: "Doors/User", fileFormat: "json") {
                if let data = try? core.rootCore.fileSystemManager.getFileData(fileName: "Doors/User", fileFormat: "json") {
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        print(user)
                        self.user = user
                    }
                }
            } else {
                let sessionConfiguration = SessionConfiguration()
                let rootSessionConfiguration = RootSessionConfiguration(sessionConfigurations: [sessionConfiguration])
                user = User(rootSessionConfiguration: rootSessionConfiguration)
                if let data = try? JSONEncoder().encode(user) {
                    if let url = try? core.rootCore.fileSystemManager.saveFileData(fileName: "Doors/User", fileFormat: "json", data: data) {
                        print(url)
                    }
                }
            }
        }
    }
}
