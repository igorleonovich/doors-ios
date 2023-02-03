//
//  SessionViewController.swift
//  Doors-iOS-Uni
//
//  Created by Igor Leonovich on 3.02.23.
//

import UIKit

final class SessionViewController: BaseViewController {

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
