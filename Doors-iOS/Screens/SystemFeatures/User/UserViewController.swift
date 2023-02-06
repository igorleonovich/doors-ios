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
    
    // MARK: Constants
    
    private let doorsFolderName = "Doors"
    private let userFileName = "User"
    
    // MARK: Setup
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(didUpdateUser),
            name: Notification.Name("DidUpdateUser"),
            object: nil)
    }
    
    // MARK: Actions
    
    func run() {
        loadInitialFeatures()
        setupNotifications()
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
            if core.rootCore.fileSystemManager.isFileExists(fileName: "\(doorsFolderName)/\(userFileName)", fileFormat: "json") {
                if let data = try? core.rootCore.fileSystemManager.getFileData(fileName: "\(doorsFolderName)/\(userFileName)", fileFormat: "json") {
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        print("[USER] User detected:\n\(user)")
                        if core.rootCore.appManager.isUserInitiallyLoaded {
                            self.user = user
                        } else {
                            print("[TODO] User detected in local file system. Do you want to load (import) it?")
                              self.user = user
//                            createNewUser()
                        }
                        core.rootCore.appManager.isUserInitiallyLoaded = true
                    }
                }
            } else {
                createNewUser()
            }
            func createNewUser() {
                let sessionConfiguration = SessionConfiguration(id: UUID.new)
                let rootSessionConfiguration = RootSessionConfiguration(sessionConfigurations: [sessionConfiguration])
                user = User(rootSessionConfiguration: rootSessionConfiguration)
                saveUser()
            }
        }
    }
    
    private func saveUser() {
        if let data = try? JSONEncoder().encode(user) {
            if let url = try? core.rootCore.fileSystemManager.saveFileData(fileName: "\(doorsFolderName)/\(userFileName)", fileFormat: "json", data: data) {
                print("[USER] File saved at:\(url.path)")
            }
        }
    }
    
    @objc private func didUpdateUser() {
        saveUser()
    }
}
