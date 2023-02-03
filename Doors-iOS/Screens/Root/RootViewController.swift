//
//  RootViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class RootViewController: BaseViewController {
    
    weak var rootCore: RootCore!
    weak var loadingViewController: LoadingViewController?
    weak var rootSessionViewController: RootSessionViewController?
    
    init(rootCore: RootCore) {
        self.rootCore = rootCore
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showLoading()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBackground()
    }
    
    private func setupBackground() {
        view.backgroundColor = Color.backgroundInactive
    }
    
    // MARK: Screens: Loading
    
    private func showLoading() {
        let loadingViewController = LoadingViewController(rootCore: rootCore)
        self.loadingViewController = loadingViewController
        add(child: loadingViewController)
    }
    
    private func closeLoading() {
        loadingViewController?.remove()
        loadingViewController = nil
    }
    
    func finishLoading() {
        showRootSession()
        closeLoading()
    }
    
    // MARK: Screens: Root Session
    
    private func showRootSession() {
        let core = Core()
        core.rootCore = rootCore
        let rootSessionViewController = RootSessionViewController(core: core)
        self.rootSessionViewController = rootSessionViewController
        add(child: rootSessionViewController)
    }
}