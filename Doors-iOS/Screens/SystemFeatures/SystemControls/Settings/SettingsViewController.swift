//
//  SettingsViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SettingsViewController: BaseSystemFeatureViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let button = UIButton()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.setImage(UIImage(named: "Settings")?.withRenderingMode(.alwaysOriginal).withTintColor(Color.foregroundActive), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func onTap() {
        showScreen()
    }
    
    private func showScreen() {
        let settingsScreenViewController = SettingsScreenViewController(core: core)
        settingsScreenViewController.modalTransitionStyle = .crossDissolve
        settingsScreenViewController.modalPresentationStyle = .overFullScreen
        (core.router as? SessionViewController)?.present(settingsScreenViewController, animated: true)
    }
}
