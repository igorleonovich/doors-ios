//
//  BlurView.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 15.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class BlurView: UIView {
    
    var blurView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(sceneDidEnterBackground),
            name: UIScene.didEnterBackgroundNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    // MARK: Actions

    @objc func sceneDidEnterBackground() {
        blurView?.alpha = 0
    }
    
    @objc func appDidBecomeActive() {
        blurView?.recover()
    }
    
    func addBlur() {
        backgroundColor = .clear
        let blurView = blurView()
        insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        func blurView(with intensity: CGFloat = 0.4) -> UIVisualEffectView {
            var blurStyle = UIBlurEffect.Style.dark
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                blurStyle = .light
            case .dark:
                break
            @unknown default:
                break
            }
            let blurEffect = UIBlurEffect(style: blurStyle)
            let blurView = UIVisualEffectView(effect: blurEffect)
            self.blurView = blurView
            blurView.setIntensity(intensity)
            return blurView
        }
    }
}
