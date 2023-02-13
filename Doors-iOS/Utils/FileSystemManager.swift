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
        guard isFileExists(fileName: fileName, fileFormat: fileFormat) else {
            throw NSErrorDomain.init(string: "Not found") as! Error
        }
        if let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw error
            }
        }
        return nil
    }
    
    func createFolder(folderName: String) throws {
        if let fileURL = fileURL(fileName: folderName, isDirectory: true) {
            do {
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw error
            }
        }
    }

    func saveFileData(fileName: String, fileFormat: String, data: Data) throws -> URL? {
        if let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
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
            let fileList = try FileManager.default.contentsOfDirectory(at: pathFrom, includingPropertiesForKeys: nil)
            for fileName in fileList {
                try FileManager.default.copyItem(at: pathFrom.appendingPathExtension("/\(fileName)"), to: pathTo.appendingPathExtension("/\(fileName)"))
            }
        } catch {
            throw error
        }
    }

    func removeFile(fileName: String, fileFormat: String) throws {
        guard isFileExists(fileName: fileName, fileFormat: fileFormat) else {
            return
        }
        if let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                throw error
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
                    throw error
                }
            }
        } catch {
            throw error
        }
    }

    func isFileExists(fileName: String, fileFormat: String) -> Bool {
        if let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            return FileManager.default.fileExists(atPath: fileURL.path)
        } else {
            return false
        }
    }

    func fileURL(fileName: String, fileFormat: String? = nil, isDirectory: Bool = false) -> URL? {
        return defaultFileDirectory()?.appendingPathComponent(fileName, isDirectory: isDirectory).appendingPathExtension(fileFormat ?? "")
    }

    func defaultFileDirectory() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.fm.doors")
    }
}
