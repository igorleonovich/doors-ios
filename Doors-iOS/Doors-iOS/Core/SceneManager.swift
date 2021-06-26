//
//  SceneManager.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 26.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import Foundation

class SceneManager {
    
    weak var core: Core!
    
    var readDataTask: URLSessionTask?
    var writeDataTask: URLSessionTask?
    
    func read(_ completion: @escaping ((Swift.Error?, ListDTO?)) -> Void) {
        readDataTask?.cancel()
        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: core.signedSessionConfiguration, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        
        guard let url = URL(string: "\(Constants.baseURL)/lists/read") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        readDataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer {
                self.readDataTask = nil
            }
            if let error = error {
                completion((error, nil))
            } else if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 200 {
                    let list = try! JSONDecoder().decode(ListDTO.self, from: data)
                    completion((nil, list))
                } else if let error = error {
                    completion((error, nil))
                }
            }
        }
        readDataTask?.signedResume(core: core)
    }
}
