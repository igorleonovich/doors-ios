//
//  ExportViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 7.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit
import Zip

final class ExportViewController: BaseSystemFeatureViewController {
    
    var closeAction: (() -> Void)? = nil
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    func run() {
        loadInitialFeatures()
    }
    
    private func loadInitialFeatures() {
        let doExportFeature = Feature(name: "doExport", dependencies: [])
        loadFeature(doExportFeature)
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "doExport" {
            do {
                let exportFolderName = "Export"
                let exportFileName = "\(exportFolderName)/Export"
                if core.rootCore.fileSystemManager.isFileExists(fileName: exportFolderName, fileFormat: "") == false {
                    core.rootCore.fileSystemManager.createFolder(folderName: exportFolderName)
                }
                let doorsFolderName = "Doors"
                if let doorsFolderURL = core.rootCore.fileSystemManager.fileURL(fileName: doorsFolderName),
                   let zipFileURL = core.rootCore.fileSystemManager.fileURL(fileName: exportFileName, fileFormat: "zip") {
                    try Zip.zipFiles(paths: [doorsFolderURL], zipFilePath: zipFileURL, password: nil, progress: { [weak self] progress -> () in
                        print("[EXPORT] Progress: \(progress)")
                        if progress == 1 {
                            print("[EXPORT] Exported into path:\n\(zipFileURL.absoluteString)")
                            self?.closeAction = {
                                let activityViewController = UIActivityViewController(activityItems: [zipFileURL], applicationActivities: nil)
                                UIApplication.rootViewController?.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
            catch {
              print(error)
            }
        }
    }
}
