//
//  UIView+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBorder(color: UIColor, width: CGFloat, sides: [BorderSide]) {
        sides.forEach { side in
            let lineView = UIView()
            addSubview(lineView)
            lineView.snp.makeConstraints { make in
                switch side {
                case .up:
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(width)
                case .down:
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-width)
                    make.height.equalTo(width)
                case .left:
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview()
                    make.width.equalTo(width)
                case .right:
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.right.equalToSuperview()
                    make.width.equalTo(width)
                }
            }
            lineView.backgroundColor = color
            lineView.isUserInteractionEnabled = false
        }
    }
}
