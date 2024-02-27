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
        if isFileExists(fileName: fileName, fileFormat: fileFormat),
           let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            return try Data(contentsOf: fileURL)
        } else if let error = NSErrorDomain.init(string: "[FILE SYSTEM MANAGER] Get: File not found") as? Error {
            print(error)
            throw error
        }
        return nil
    }
    
    func createFolder(folderName: String) throws {
        if let fileURL = fileURL(fileName: folderName, isDirectory: true) {
            do {
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("[FILE SYSTEM MANAGER]\n\(error)")
                throw error
            }
        } else if let error = NSErrorDomain.init(string: "[FILE SYSTEM MANAGER] Create Folder: Can't create URL") as? Error {
            print(error)
            throw error
        }
    }

    func saveFile(fileName: String, fileFormat: String, data: Data) throws -> URL? {
        if let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            if FileManager.default.createFile(atPath: fileURL.path, contents: data,
                                              attributes: [FileAttributeKey.protectionKey: FileProtectionType.complete]) {
                return fileURL
            } else {
                if let error = NSErrorDomain.init(string: "[FILE SYSTEM MANAGER] Unable to save file at:\n\(fileURL.absoluteString)") as? Error {
                    print(error)
                    throw error
                }
                return nil
            }
        } else if let error = NSErrorDomain.init(string: "[FILE SYSTEM MANAGER] Save File: Can't create URL") as? Error {
            print(error)
            throw error
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
            print("[FILE SYSTEM MANAGER]\n\(error)")
            throw error
        }
    }

    func removeFile(fileName: String, fileFormat: String) throws {
        if isFileExists(fileName: fileName, fileFormat: fileFormat),
           let fileURL = fileURL(fileName: fileName, fileFormat: fileFormat) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("[FILE SYSTEM MANAGER]\n\(error)")
                throw(error)
            }
        } else if let error = NSErrorDomain.init(string: "[FILE SYSTEM MANAGER] Remove: File not found") as? Error {
            print(error)
            throw error
        }
    }
    
    func removeAllFiles() throws {
        do {
            try [defaultFileDirectory()].compactMap({$0}).forEach { url in
                let fileURLs = try FileManager.default.contentsOfDirectory(at: url,
                                                                           includingPropertiesForKeys: nil,
                                                                           options: [])
                try fileURLs.forEach({ try FileManager.default.removeItem(at: $0) })
            }
        } catch {
            print("[FILE SYSTEM MANAGER]\n\(error)")
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
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroup)
    }
}
