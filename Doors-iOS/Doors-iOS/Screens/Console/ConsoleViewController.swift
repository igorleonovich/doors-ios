//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit
import MBProgressHUD
import Rswift

class ConsoleViewController: BaseNavigableViewController {
    
    var checkDataTask: URLSessionTask?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSide: CGFloat = 100.0
    let cellSize = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Console"
        collectionView.register(R.nib.doorsServiceCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.signedCall { error in
            print("")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func signedCall(_ completion: @escaping (Swift.Error?) -> Void) {
        checkDataTask?.cancel()
        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: core.signedSessionConfiguration, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        
        guard let url = URL(string: "\(Constants.baseURL)/users/me") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        checkDataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer {
                self.checkDataTask = nil
            }
            if let error = error {
                completion(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 200 {
                    let user = try! JSONDecoder().decode(UserPrivateInput.self, from: data)
                    print(user)
                    completion(nil)
                } else if let error = error {
                    completion(error)
                }
            }
        }
        checkDataTask?.signedResume(core: core)
    }
}
