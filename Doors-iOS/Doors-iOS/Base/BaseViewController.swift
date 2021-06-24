//
//  BasicViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint?
    
    var considerBottomSafeArea = false
    var initialBottomIndent: CGFloat = 0.0
    
    init(isModal: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        if !isModal {
            self.modalSetup()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerHeightConstraint?.constant = view.frame.height
    }
    
    private func modalSetup() {
        if modalPresentationStyle == .pageSheet {
            modalPresentationStyle = .overCurrentContext
        }
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
    func setupHidingKeyboardTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupKeyboard() {
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShow(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHide(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let bottomConstraint = bottomConstraint,
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        var shiftHeight = keyboardFrame.height
        if considerBottomSafeArea {
            shiftHeight -= Device.bottomSafeAreaInsets
        }
        bottomConstraint.constant = shiftHeight
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let bottomConstraint = bottomConstraint else { return }
        bottomConstraint.constant = initialBottomIndent
        view.setNeedsLayout()
    }
    
    @objc func hideKeyboard(_ sender: AnyObject) {
        view.endEditing(false)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

class BaseNavigableViewController: BaseViewController {
    
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
        navigationController?.navigationBar.tintColor = .black
        let image = UIImage(systemName: "text.justify")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menuButtonTapped(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func menuButtonTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.core.authManager.logOut { [weak self] error in
                guard let `self` = self else { return }
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    guard let rootViewController = self.navigationController?.parent as? RootViewController else { return }
                    rootViewController.removeConsoleNavigationController()
                    rootViewController.showAuthNavigationController()
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        [logOutAction, cancelAction].forEach { optionMenu.addAction($0) }
        self.parent?.present(optionMenu, animated: true, completion: nil)
    }
}
