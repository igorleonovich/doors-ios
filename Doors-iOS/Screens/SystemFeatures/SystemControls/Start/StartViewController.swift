//
//  MagicButtonViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class StartViewController: BaseSystemFeatureViewController {
    
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
        let button = Button()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.setImage(UIImage(named: "Start")?.withRenderingMode(.alwaysOriginal).withTintColor(Color.foregroundActive), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        
        //  let circle = UIView()
        //  button.addSubview(circle)
        //  circle.snp.makeConstraints { make in
        //      make.top.equalTo(2)
        //      make.bottom.equalTo(-2)
        //      make.left.equalToSuperview()
        //      make.right.equalToSuperview()
        //  }
        //  circle.backgroundColor = Color.foregroundActive
        //  circle.clipsToBounds = true
        //  circle.layer.cornerRadius = 15
        //  circle.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions
    
    @objc private func onTap() {
        showScreen()
    }
    
    private func showScreen() {
        if let feature = feature {
            let startScreenFeature = Feature(name: "startScreen", dependencies: [feature])
            let startScreenViewController = StartScreenViewController(core: core, feature: startScreenFeature)
            startScreenFeature.viewController = startScreenViewController
            startScreenViewController.modalTransitionStyle = .crossDissolve
            startScreenViewController.modalPresentationStyle = .overFullScreen
            present(startScreenViewController, animated: true)
        }
    }
}
