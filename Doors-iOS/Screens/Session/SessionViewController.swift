//
//  SessionViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class SessionViewController: BaseViewController {

    weak var core: Core!
    weak var mainViewController: MainViewController?
    
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
    
    // MARK: - Setup
    
    private func setupUI() {
        showMain()
    }
    
    
    // MARK: Actions
    
    private func showMain() {
        let mainViewController = MainViewController(core: core)
        add(child: mainViewController)
        view.addSubview(mainViewController.view)
        self.mainViewController = mainViewController
    }
}
