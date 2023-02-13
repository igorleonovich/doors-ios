//
//  UINavigationController+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 11.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

public extension UINavigationController {

    func pop(transitionType: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        addTransition(transitionType: transitionType, duration: duration)
        popViewController(animated: false)
    }

    func push(viewController: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        addTransition(transitionType: type, duration: duration)
        pushViewController(viewController, animated: false)
    }

    private func addTransition(transitionType: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = transitionType
        view.layer.add(transition, forKey: nil)
    }
}
