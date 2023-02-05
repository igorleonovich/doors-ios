//
//  TableView.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

class TableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
