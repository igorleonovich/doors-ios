//
//  ForgotPasswordViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/10/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    weak var core: Core!
    
    @IBOutlet weak var recoverButton: CustomButton!
    @IBOutlet weak var backButton: CustomButton!
    
    
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
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupAppearance() {
        recoverButton.backgroundColor = UIColor.backgroundActive
        recoverButton.setTitleColor(UIColor.backgroundInactive , for: .normal)
        backButton.backgroundColor = UIColor.backgroundInactive
        backButton.setTitleColor(UIColor.foregroundActive, for: .normal)
    }
    
    @IBAction func recoverButtonTapped(_ sender: Any) {
        
    }
}
