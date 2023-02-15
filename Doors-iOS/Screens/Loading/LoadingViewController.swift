//
//  ViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class LoadingViewController: BaseViewController {

    weak var rootCore: RootCore!
    
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
        performLoading()
    }
    
    // MARK: Setup
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    private func performLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.finishLoading()
        }
    }
    
    private func finishLoading() {
        UIApplication.rootViewController?.finishLoading()
    }
}
