//
//  UserManager.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import Foundation

class UserManager {
    
    var core: Core!
    
    private lazy var userFileURL: URL? = {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directoryURL.appendingPathComponent("user.json")
        print(fileURL)
        return fileURL
    }()
    
    var user: User? {
        get {
            do {
                guard let userFileURL = userFileURL else { return nil }
                let data = try Data(contentsOf: userFileURL)
                return try JSONDecoder().decode(User.self, from: data)
            } catch {
                print(error)
                return nil
            }
        }
        set {
            guard let userFileURL = userFileURL else { return }
            do {
                if newValue == nil {
                    try FileManager.default.removeItem(at: userFileURL)
                } else {
                    let data = try JSONEncoder().encode(newValue)
                    try data.write(to: userFileURL)
                }
            } catch {
                print(error)
            }
        }
    }
}
