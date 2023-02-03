//
//  RootViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

class OldRootViewController: OldBaseViewController {
    
    let centerView = UIView()
    
    weak var core: OldCore!
    
    var loadingViewController: UIViewController?
    var authNavigationController: UINavigationController?
    var constructorNavigationController: UINavigationController?
    
    init(core: OldCore) {
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
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.backgroundInactive
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
        let loadingViewController = OldLoadingViewController(core: core)
        loadingViewController.delegate = self
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
    
    private func removeLoadingViewController() {
        guard let loadingViewController = loadingViewController else { return }
        loadingViewController.willMove(toParent: nil)
        loadingViewController.view.removeFromSuperview()
        loadingViewController.removeFromParent()
        self.loadingViewController = nil
    }
    
    func showConstructorNavigationController() {
        let constructorViewController = ConstructorViewController(core: core)
        let constructorNavigationController = ConstructorNavigationController(rootViewController: constructorViewController)
        addChild(constructorNavigationController)
        constructorNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(constructorNavigationController.view)
        constructorNavigationController.view.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        constructorNavigationController.view.leadingAnchor.constraint(equalTo: centerView.leadingAnchor).isActive = true
        constructorNavigationController.view.trailingAnchor.constraint(equalTo: centerView.trailingAnchor).isActive = true
        constructorNavigationController.view.bottomAnchor.constraint(equalTo: centerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        constructorNavigationController.didMove(toParent: self)
        self.constructorNavigationController = constructorNavigationController
        
        removeAuthNavigationController()
    }
    
    func removeConstructorNavigationController() {
        guard let constructorNavigationController = constructorNavigationController else { return }
        constructorNavigationController.willMove(toParent: nil)
        constructorNavigationController.view.removeFromSuperview()
        constructorNavigationController.removeFromParent()
        self.constructorNavigationController = nil
    }
    
    private func removeAuthNavigationController() {
        guard let authNavigationController = authNavigationController else { return }
        authNavigationController.willMove(toParent: nil)
        authNavigationController.view.removeFromSuperview()
        authNavigationController.removeFromParent()
        self.authNavigationController = nil
    }
}

extension OldRootViewController: LoadingViewControllerDelegate {
    
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
}
