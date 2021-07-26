//
//  LoginViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit
import MBProgressHUD

class LogInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var forgotPasswordButton: CustomButton!
    
    weak var core: Core!
    
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
        [logInButton].forEach { button in
            button?.backgroundColor = UIColor.backgroundActive
            button?.setTitleColor(UIColor.backgroundInactive , for: .normal)
        }
        [signUpButton, forgotPasswordButton].forEach { button in
            button?.backgroundColor = UIColor.backgroundInactive
            button?.setTitleColor(UIColor.foregroundActive, for: .normal)
        }
        
        [emailTextField, passwordTextField].forEach({ $0?.font = UIFont.systemFont(ofSize: Constants.Skin.fontSize, weight: .ultraLight) })
        
        [logInButton, signUpButton, forgotPasswordButton].forEach{($0?.titleLabel?.font = UIFont.systemFont(ofSize: Constants.Skin.fontSize, weight: .black))}
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        let login = LoginOutput(email: email, password: password)
        core.authManager.logIn(login: login) { [weak self] error in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                let alert = CustomAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = CustomAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                guard let rootViewController = self.navigationController?.parent as? RootViewController else { return }
                rootViewController.showConsoleNavigationController()
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let vc = SignUpViewController(core: core)
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController(core: core)
        navigationController?.pushViewController(vc, animated: false)
    }
}
