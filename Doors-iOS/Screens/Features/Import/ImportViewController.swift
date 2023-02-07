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
        }
    }
}

extension ImportViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        do {
            if let zipFileURL = urls.first, let importFolderURL = core.rootCore.fileSystemManager.fileURL(fileName: "Import"),
                let doorsURL = core.rootCore.fileSystemManager.fileURL(fileName: "Doors") {
                try Zip.unzipFile(zipFileURL, destination: importFolderURL, overwrite: true, password: nil, progress: { [weak self] progress -> () in
                    print("\n[IMPORT] Progress: \(progress)")
                    if progress == 1 {
                        print("\n[IMPORT] Imported into path:\n\(importFolderURL.absoluteString)")
                        print("\n[TODO] [IMPORT] Verify imported data")
                        print("\n[TODO] [IMPORT] Do you really want to overwrite current user?")
                        try? self?.core.rootCore.fileSystemManager.removeFile(fileName: "Doors", fileFormat: "")
                        let importedDoorsURL = importFolderURL.appendingPathComponent("Doors")
                        try? self?.core.rootCore.fileSystemManager.copyFiles(pathFrom: importedDoorsURL, pathTo: doorsURL)
                        UIApplication.rootViewController?.reloadRootSesion()
                        try? self?.core.rootCore.fileSystemManager.removeFile(fileName: "Import", fileFormat: "")
                    }
                })
            }
        } catch {
            print(error)
        }
    }
}
