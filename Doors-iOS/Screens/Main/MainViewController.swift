//
//  MainViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class MainViewController: BaseViewController {
    
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
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .darkGray
    }
}
