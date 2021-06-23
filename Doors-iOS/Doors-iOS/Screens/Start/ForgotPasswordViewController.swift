//
//  ForgotPasswordViewController.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/10/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    let core: Core
    
    init(core: Core) {
        self.core = core
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHidingKeyboardTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func recoverButtonTapped(_ sender: Any) {
        
    }
}
