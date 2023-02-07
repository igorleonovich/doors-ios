//
//  ImportViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 7.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit
import Zip

final class ImportViewController: BaseSystemFeatureViewController {
    
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
        let doImportFeature = Feature(name: "doImport", dependencies: [])
        loadFeature(doImportFeature)
    }
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "doImport" {
            closeAction = {
                if #available(iOS 14.0, *) {
                    let pickerViewController = UIDocumentPickerViewController(documentTypes: ["com.pkware.zip-archive"], in: .import)
                    pickerViewController.delegate = self
                    pickerViewController.allowsMultipleSelection = true
                    pickerViewController.shouldShowFileExtensions = true
                    UIApplication.rootViewController?.present(pickerViewController, animated: true, completion: nil)
                }
            }
            
            
            do {
//                let exportFolderName = "Export"
//                let exportFileName = "\(exportFolderName)/Export"
//                if core.rootCore.fileSystemManager.isFileExists(fileName: exportFolderName, fileFormat: "") == false {
//                    core.rootCore.fileSystemManager.createFolder(folderName: exportFolderName)
//                }
//                let doorsFolderName = "Doors"
//                if let doorsPath = core.rootCore.fileSystemManager.fileURL(fileName: doorsFolderName),
//                   let zipFilePath = core.rootCore.fileSystemManager.fileURL(fileName: exportFileName, fileFormat: "zip") {
//                    try Zip.zipFiles(paths: [doorsPath], zipFilePath: zipFilePath, password: nil, progress: { [weak self] (progress) -> () in
//                        print("[EXPORT] Progress: \(progress)")
//                        if progress == 1 {
//                            print("[EXPORT] Exported into path:\n\(zipFilePath)")
//                            self?.closeAction = {
//                                let activityViewController = UIActivityViewController(activityItems: [zipFilePath], applicationActivities: nil)
//                                UIApplication.rootViewController?.present(activityViewController, animated: true, completion: nil)
//                            }
//                        }
//                    })
//                }
            }
            catch {
              print(error)
            }
        }
    }
}

extension ImportViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        do {
            if let zipFile = urls.first, let destination = core.rootCore.fileSystemManager.fileURL(fileName: "Import") {
                try Zip.unzipFile(zipFile, destination: destination, overwrite: true, password: "password", progress: { (progress) -> () in
                    print(progress)
                })
            }
        } catch {
            print(error)
        }
    }
}
