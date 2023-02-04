//
//  MagicButtonViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class StartViewController: BaseSystemFeatureViewController {

    private weak var core: Core!
    
    init(core: Core) {
        self.core = core
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        button.setImage(UIImage(named: "Start")?.withRenderingMode(.alwaysOriginal).withTintColor(Color.foregroundActive), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func onTap() {
        showScreen()
    }
    
    private func showScreen() {
        let startScreenViewController = StartScreenViewController(core: core)
        startScreenViewController.modalTransitionStyle = .crossDissolve
        startScreenViewController.modalPresentationStyle = .overFullScreen
        (core.router as? SessionViewController)?.present(startScreenViewController, animated: true)
    }
}
