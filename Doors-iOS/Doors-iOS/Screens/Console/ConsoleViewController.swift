//
//  ConsoleViewController.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import UIKit
import MBProgressHUD

class ConsoleViewController: BaseViewController {
    
    let core: Core
    
    var checkDataTask: URLSessionTask?
    
    init(core: Core) {
        self.core = core
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.signedCall { error in
            print("")
        }
    }
    
    func signedCall(_ completion: @escaping (Swift.Error?) -> Void) {
        checkDataTask?.cancel()
        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: core.signedSessionConfiguration, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        
        guard let url = URL(string: "\(Constants.baseURL)users/profile") else {
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
                    let user = try! JSONDecoder().decode(UserSuccessInput.self, from: data)
                    print(user)
                    completion(nil)
                } else if let error = error {
                    completion(error)
                }
            }
        }
        checkDataTask?.signedResume(core: core)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.core.authManager.logOut { [weak self] error in
                guard let `self` = self else { return }
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let rootViewController = self.navigationController?.parent as? RootViewController else { return }
                    rootViewController.removeConsoleNavigationController()
                    rootViewController.showAuthNavigationController()
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [logOutAction, cancelAction].forEach { optionMenu.addAction($0) }
        self.parent?.present(optionMenu, animated: true, completion: nil)
    }
}
