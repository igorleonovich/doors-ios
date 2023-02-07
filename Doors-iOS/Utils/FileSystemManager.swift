//
//  FileSystemManager.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 6.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import Foundation

final class FileSystemManager {
    
    func getFileData(fileName: String, fileFormat: String) throws -> Data? {
        guard self.isFileExists(fileName: fileName, fileFormat: fileFormat) else {
            throw NSErrorDomain.init(string: "Not found") as! Error
        }
        if let fileURL = self.fileURL(fileName: fileName, fileFormat: fileFormat) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw NSErrorDomain.init(string: "Unable to read data!") as! Error
            }
        }
        return nil
    }
    
    func createFolder(folderName: String) {
        if let fileURL = self.fileURL(fileName: folderName, isDirectory: true) {
            do {
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveFileData(fileName: String, fileFormat: String, data: Data) throws -> URL? {
        if let fileURL = self.fileURL(fileName: fileName, fileFormat: fileFormat) {
            guard FileManager.default.createFile(atPath: fileURL.path,
                                                 contents: data,
                                                 attributes: [FileAttributeKey.protectionKey:
                                                                FileProtectionType.complete ]) else {
                throw NSErrorDomain.init(string: "Unable to write data!") as! Error
            }
            return fileURL
        }
        return nil
    }
    
    func copyFiles(pathFrom: URL, pathTo: URL) throws {
        do {
            let filelist = try FileManager.default.contentsOfDirectory(at: pathFrom, includingPropertiesForKeys: nil)
            try? FileManager.default.copyItem(at: pathFrom, to: pathTo)
            for filename in filelist {
                try? FileManager.default.copyItem(at: pathFrom.appendingPathExtension("/\(filename)"), to: pathTo.appendingPathExtension("/\(filename)"))
            }
        } catch {
            throw error
        }
    }

    func removeFile(fileName: String, fileFormat: String) throws {
        guard self.isFileExists(fileName: fileName, fileFormat: fileFormat) else {
            return
        }
        if let fileURL = self.fileURL(fileName: fileName, fileFormat: fileFormat) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                throw NSErrorDomain.init(string: "Unable to remove data!") as! Error
            }
        }
    }
    
    func removeAllFiles() throws {
        do {
            try [defaultFileDirectory()].compactMap({$0}).forEach { url in
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: url,
                                                                               includingPropertiesForKeys: nil,
                                                                               options: [.skipsHiddenFiles,
                                                                                         .skipsSubdirectoryDescendants])
                    for fileURL in fileURLs {
                        try FileManager.default.removeItem(at: fileURL)
                    }
                } catch {
                    throw NSErrorDomain.init(string: errorText()) as! Error
                }
            }
        } catch {
            throw NSErrorDomain.init(string: errorText()) as! Error
        }
        func errorText() -> String {
            return "Unable to remove all data!"
        }
    }

    func isFileExists(fileName: String, fileFormat: String) -> Bool {
        if let fileURL = self.fileURL(fileName: fileName, fileFormat: fileFormat) {
            let exists = FileManager.default.fileExists(atPath: fileURL.path)
            return exists
        } else {
            return false
        }
    }

    func fileURL(fileName: String, fileFormat: String? = nil, isDirectory: Bool = false) -> URL? {
        return self.defaultFileDirectory()?.appendingPathComponent(fileName, isDirectory: isDirectory).appendingPathExtension(fileFormat ?? "")
    }

    func defaultFileDirectory() -> URL? {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.fm.doors")
        return url
    }
}
