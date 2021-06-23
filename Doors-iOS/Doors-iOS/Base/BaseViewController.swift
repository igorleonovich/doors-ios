//
//  BasicViewController.swift
//  Subtuner
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IELIS. All rights reserved.
//

import UIKit

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
