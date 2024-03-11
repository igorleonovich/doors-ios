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
    
    private var appFamilyFolderName: String {
        var domainName = Domain.defaultDomainName
        if user != nil {
            domainName = user.rootDomain.name
        }
        return "Clusters/1/Domains/\(domainName)/.doors"
    }
    private let userFileName = "User"
    
    // MARK: Setup
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateUser),
                                               name: Notification.Name.didUpdateUser,
                                               object: nil)
    }
    
    // MARK: Actions
    
    func run() {
        loadInitialFeatures()
        setupNotifications()
    }
    
    private func loadInitialFeatures() {
        let checkAppFamilyFolderFeature = Feature(name: "checkAppFamilyFolder")
        let setupUserFeature = Feature(name: "setupUser")
        [checkAppFamilyFolderFeature, setupUserFeature].forEach({ loadChildFeature($0) })
    }
    
    override func loadChildFeature(_ feature: Feature) {
        super.loadChildFeature(feature)
        if feature.name == "checkAppFamilyFolder" {
            if core.rootCore.fileSystemManager.isFileExists(fileName: appFamilyFolderName, fileFormat: "") == false {
                try? core.rootCore.fileSystemManager.createFolder(folderName: appFamilyFolderName)
            }
            if let path = core.rootCore.fileSystemManager.fileURL(fileName: appFamilyFolderName, fileFormat: "")?.path {
                print("\n[USER] App family folder:\n\(path)")
            }
        } else if feature.name == "setupUser" {
            if core.rootCore.fileSystemManager.isFileExists(fileName: "\(appFamilyFolderName)/\(userFileName)", fileFormat: "json") {
                do {
                    if let data = try core.rootCore.fileSystemManager.getFileData(fileName: "\(appFamilyFolderName)/\(userFileName)", fileFormat: "json") {
                        do {
                            let user = try JSONDecoder().decode(User.self, from: data)
                            print("\n[USER] User detected:\n\(user)")
                            if core.rootCore.appManager.isUserInitiallyLoaded {
                                self.user = user
                            } else {
                                print("\n[TODO] [USER] User detected in local file system. Do you want to load (import) it?")
                                self.user = user
    //                            createNewUser()
                            }
                        } catch {
                            print(error)
                        }
                    }
                } catch {
                    createNewUser()
                }
            } else {
                createNewUser()
            }
            core.rootCore.appManager.isUserInitiallyLoaded = true
            
            func createNewUser() {
                if let featureMap = core.rootCore.appManager.featureMap {
                    let rootDomain = Domain(featureMap: featureMap)
                    let sessionConfiguration = SessionConfiguration(domainId: rootDomain.id)
                    let rootSessionConfiguration = RootSessionConfiguration(sessionConfigurations: [sessionConfiguration])
                    if let featureMap = core.rootCore.appManager.featureMap {
                        user = User(rootSessionConfiguration: rootSessionConfiguration, rootDomain: rootDomain)
                    } else {
                        print("[USER] Error: Cannot find featureMap")
                    }
                    saveUser()
                } else {
                    print("[USER] Error: Cannot find featureMap")
                }
            }
        }
    }
    
    func saveUser() {
        do {
            let data = try JSONEncoder().encode(user)
            if let url = try? core.rootCore.fileSystemManager.saveFile(fileName: "\(appFamilyFolderName)/\(userFileName)", fileFormat: "json", data: data) {
                print("\n[USER] File saved at:\(url.path)")
            }
        } catch {
            print(error)
        }
    }
    
    @objc private func didUpdateUser() {
        saveUser()
    }
}
