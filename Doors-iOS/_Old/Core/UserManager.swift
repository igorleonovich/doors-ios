//
//  UserManager.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/12/20.
//  Copyright © 2020 IL. All rights reserved.
//

import Foundation

class UserManager {
    
    weak var core: Core!
    
    var getUserProfileDataTask: URLSessionTask?
    var activateDoorsServiceDataTask: URLSessionTask?
    
    private lazy var userFileURL: URL? = {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directoryURL.appendingPathComponent("user.json")
        print(fileURL)
        return fileURL
    }()
    
    var user: UserPrivateInput? {
        get {
            do {
                guard let userFileURL = userFileURL else { return nil }
                let data = try Data(contentsOf: userFileURL)
                return try JSONDecoder().decode(UserPrivateInput.self, from: data)
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
    
    func getUserProfile(_ completion: @escaping (Swift.Error?) -> Void) {
        getUserProfileDataTask?.cancel()
        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: core.signedSessionConfiguration, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        
        guard let url = URL(string: "\(Constants.baseURL)/users/me") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        getUserProfileDataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer {
                self.getUserProfileDataTask = nil
            }
            if let error = error {
                completion(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 200 {
                    let user = try! JSONDecoder().decode(UserPrivateInput.self, from: data)
                    self.user = user
                    print(user)
                    completion(nil)
                } else if let error = error {
                    completion(error)
                }
            }
        }
        getUserProfileDataTask?.signedResume(core: core)
    }
    
    func activateDoorsService(doorsService: DoorsService, _ completion: @escaping (Swift.Error?) -> Void) {
        activateDoorsServiceDataTask?.cancel()
        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: core.signedSessionConfiguration, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        
        guard let url = URL(string: "\(Constants.baseURL)/doors-services/\(doorsService.rawValue)/activate") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        activateDoorsServiceDataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer {
                self.activateDoorsServiceDataTask = nil
            }
            if let error = error {
                completion(error)
            } else if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 204 {
                    completion(nil)
                } else if let error = error {
                    completion(error)
                }
            }
        }
        activateDoorsServiceDataTask?.signedResume(core: core)
    }
}
