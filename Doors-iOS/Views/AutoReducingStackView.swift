//
//  AutoReducingStackView.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class AutoReducingStackView: UIStackView {
    
    override func removeArrangedSubview(_ view: UIView) {
        if arrangedSubviews.count % 2 != 0 {
            (superview as? UIStackView)?.removeArrangedSubview(self)
        } else {
            super.removeArrangedSubview(view)
        }
    }
}
