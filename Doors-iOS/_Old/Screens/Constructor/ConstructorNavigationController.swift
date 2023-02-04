//
//  ConstructorNavigationController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 24.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit

class ConstructorNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Skin.font
        ]
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Color.backgroundInactive
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Skin.font
        ]
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.buttonAppearance = buttonAppearance
        
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.compactAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}
