//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class ConsoleViewController: BaseFeatureViewController {

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
        view.backgroundColor = .systemIndigo
    }
}

