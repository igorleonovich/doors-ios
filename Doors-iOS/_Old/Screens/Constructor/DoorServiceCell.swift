//
//  DoorServiceCell.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 23.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit

class DoorServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = false
    }
    
    func configure(with doorsService: DoorsService, isActive: Bool) {
        contentView.layer.borderColor = isActive ? Color.foregroundActive.cgColor : Color.foregroundInactive.cgColor
        titleLabel.textColor = isActive ? Color.foregroundActive : Color.foregroundInactive
        titleLabel.text = doorsService.humanReadableTitle()
    }
}
