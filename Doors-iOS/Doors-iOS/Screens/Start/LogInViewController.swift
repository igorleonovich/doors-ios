//
//  LoginViewController.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import UIKit
import MBProgressHUD

class LogInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        let login = LoginOutput(email: email, password: password)
        core.authManager.logIn(login: login) { [weak self] error in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
