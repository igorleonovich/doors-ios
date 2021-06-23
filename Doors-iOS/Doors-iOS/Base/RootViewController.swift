//
//  RootViewController.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {
    
    let centerView = UIView()
    
    let core: Core
    
    var loadingViewController: UIViewController?
    var authNavigationController: UINavigationController?
    var consoleNavigationController: UINavigationController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(core: Core) {
        self.core = core
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAuthNavigationController()
    }
    
    private func setupUI() {
        setupCenterView()
        showLoadingViewController()
    }
    
    private func setupCenterView() {
        centerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerView)
        centerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        centerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        centerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func showLoadingViewController() {
        let loadingViewController = LoadingViewController()
        addChild(loadingViewController)
        
        loadingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(loadingViewController.view)
        
        loadingViewController.view.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        loadingViewController.view.leadingAnchor.constraint(equalTo: centerView.leadingAnchor).isActive = true
        loadingViewController.view.trailingAnchor.constraint(equalTo: centerView.trailingAnchor).isActive = true
        loadingViewController.view.bottomAnchor.constraint(equalTo: centerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        loadingViewController.didMove(toParent: self)
        self.loadingViewController = loadingViewController
    }
    
    func showAuthNavigationController() {
        let logInViewController = LogInViewController(core: core)
        let authNavigationController = UINavigationController(rootViewController: logInViewController)
        addChild(authNavigationController)
        authNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(authNavigationController.view)
        authNavigationController.view.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        authNavigationController.view.leadingAnchor.constraint(equalTo: centerView.leadingAnchor).isActive = true
        authNavigationController.view.trailingAnchor.constraint(equalTo: centerView.trailingAnchor).isActive = true
        authNavigationController.view.bottomAnchor.constraint(equalTo: centerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        authNavigationController.didMove(toParent: self)
        self.authNavigationController = authNavigationController
    }
    
    private func removeLoadingViewController() {
        guard let loadingViewController = loadingViewController else { return }
        loadingViewController.willMove(toParent: nil)
        loadingViewController.view.removeFromSuperview()
        loadingViewController.removeFromParent()
        self.loadingViewController = nil
    }
    
    func showConsoleNavigationController() {
        let consoleViewController = ConsoleViewController(core: core)
        let consoleNavigationController = UINavigationController(rootViewController: consoleViewController)
        addChild(consoleNavigationController)
        consoleNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(consoleNavigationController.view)
        consoleNavigationController.view.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        consoleNavigationController.view.leadingAnchor.constraint(equalTo: centerView.leadingAnchor).isActive = true
        consoleNavigationController.view.trailingAnchor.constraint(equalTo: centerView.trailingAnchor).isActive = true
        consoleNavigationController.view.bottomAnchor.constraint(equalTo: centerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        consoleNavigationController.didMove(toParent: self)
        self.consoleNavigationController = consoleNavigationController
        
        removeAuthNavigationController()
    }
    
    func removeConsoleNavigationController() {
        guard let consoleNavigationController = consoleNavigationController else { return }
        consoleNavigationController.willMove(toParent: nil)
        consoleNavigationController.view.removeFromSuperview()
        consoleNavigationController.removeFromParent()
        self.consoleNavigationController = nil
    }
    
    private func removeAuthNavigationController() {
        guard let authNavigationController = authNavigationController else { return }
        authNavigationController.willMove(toParent: nil)
        authNavigationController.view.removeFromSuperview()
        authNavigationController.removeFromParent()
        self.authNavigationController = nil
    }
}
