//
//  ViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class LoadingViewController: BaseViewController {

    weak var rootCore: RootCore!
    
    init(rootCore: RootCore) {
        self.rootCore = rootCore
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        performLoading()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
    }
    
    // MARK: - Actions
    
    private func performLoading() {

        Task { @MainActor in
            var iconName = ""
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                   iconName = "Doors-iOS-Dark"
                } else {
                    iconName = "Doors-iOS-Dark"
                }
            }
                guard UIApplication.shared.alternateIconName != iconName else {
                    /// No need to update since we're already using this icon.
                    return
                }

                do {
                    try await UIApplication.shared.setAlternateIconName(iconName)
                } catch {
                    /// We're only logging the error here and not actively handling the app icon failure
                    /// since it's very unlikely to fail.
                    print("Updating icon to \(String(describing: iconName)) failed.")

                    /// Restore previous app icon
//                    selectedAppIcon = previousAppIcon
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.finishLoading()
        }
    }
    
    private func finishLoading() {
        UIApplication.rootViewController?.finishLoading()
    }
}
