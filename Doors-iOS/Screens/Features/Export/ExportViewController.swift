//
//  ExportViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 7.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit
import Zip

final class ExportViewController: BaseFeatureViewController {
    
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
        let doExportFeature = Feature(name: "doExport")
        loadChildFeature(doExportFeature)
    }
    
    override func loadChildFeature(_ feature: Feature) {
        super.loadChildFeature(feature)
        if feature.name == "doExport" {
            do {
                let exportFolderName = "Export"
                let exportFileName = "\(exportFolderName)/Doors"
                if core.rootCore.fileSystemManager.isFileExists(fileName: exportFolderName, fileFormat: "") == false {
                    try? core.rootCore.fileSystemManager.createFolder(folderName: exportFolderName)
                }
                let doorsFolderName = "Doors"
                if let doorsFolderURL = core.rootCore.fileSystemManager.fileURL(fileName: doorsFolderName),
                   let zipFileURL = core.rootCore.fileSystemManager.fileURL(fileName: exportFileName, fileFormat: "zip") {
                    try Zip.zipFiles(paths: [doorsFolderURL], zipFilePath: zipFileURL, password: nil, progress: { progress -> () in
                        print("\n[EXPORT] Progress: \(progress)")
                        if progress == 1 {
                            print("\n[EXPORT] Exported into path:\n\(zipFileURL.absoluteString)")
                            let activityViewController = UIActivityViewController(activityItems: [zipFileURL], applicationActivities: nil)
                            UIApplication.rootViewController?.present(activityViewController, animated: true, completion: nil)
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
