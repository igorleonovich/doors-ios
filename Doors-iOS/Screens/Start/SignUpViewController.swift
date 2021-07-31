//
//  SignUpViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignUpViewController: BaseViewController {
    
    weak var core: Core!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: CustomButton!
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
        signUpButton.backgroundColor = UIColor.backgroundActive
        signUpButton.setTitleColor(UIColor.backgroundInactive , for: .normal)
        backButton.backgroundColor = UIColor.backgroundInactive
        backButton.setTitleColor(UIColor.foregroundActive, for: .normal)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        let newUser = NewUserOutput(username: username, email: email, password: password, confirmPassword: password)
        core.authManager.signUp(newUser: newUser) { [weak self] error in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                let alert = CustomAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = CustomAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let rootViewController = self.navigationController?.parent as? RootViewController else { return }
                rootViewController.showConstructorNavigationController()
            }
        }
    }
}
