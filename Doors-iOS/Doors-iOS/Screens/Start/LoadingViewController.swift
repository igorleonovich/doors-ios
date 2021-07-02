//
//  ViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/5/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    weak var core: Core!
    
    weak var delegate: LoadingViewControllerDelegate?
    
    var isInitialSetupPerformed = false
    
    init(core: Core) {
        self.core = core
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isInitialSetupPerformed == false {
            if core.userManager.user != nil {
                delegate?.showConsoleNavigationController()
            } else {
                delegate?.showAuthNavigationController()
            }
            isInitialSetupPerformed = true
        }
    }
}

protocol LoadingViewControllerDelegate: AnyObject {
    
    func showAuthNavigationController()
    func showConsoleNavigationController()
}
