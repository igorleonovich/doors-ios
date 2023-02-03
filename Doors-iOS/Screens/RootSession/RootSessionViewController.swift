//
//  RootSessionViewController.swift
//  Doors-iOS-Uni
//
//  Created by Igor Leonovich on 3.02.23.
//

import UIKit

final class RootSessionViewController: BaseViewController {

    var core: Core!
    weak var currentSessionViewController: SessionViewController!
    
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
        loadDefaultSession()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    // MARK: Actions
    
    private func loadDefaultSession() {
        let sessionViewController = SessionViewController(core: core)
        addChild(sessionViewController)
        view.addSubview(sessionViewController.view)
        sessionViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.currentSessionViewController = sessionViewController
    }
}
