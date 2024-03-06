//
//  MenuTableViewCell.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 05/03/2024.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

class MenuTableViewCell: TableViewCell {
    
    var toggleButton: Button!
    var titleLabel: Label!
    var arrowLabel: Label!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        stackView.spacing = 10
        
        stackView.addArrangedSubview(UIView())
        
        toggleButton = Button()
        toggleButton.addTarget(self, action: #selector(onToggle), for: .touchUpInside)
        toggleButton.backgroundColor = .green
        toggleButton.clipsToBounds = true
        toggleButton.layer.cornerRadius = 6
        toggleButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        toggleButton.isHidden = true
        stackView.addArrangedSubview(toggleButton)
        
        titleLabel = Label()
        stackView.addArrangedSubview(titleLabel)
        
        arrowLabel = Label()
        arrowLabel.text = ">"
        arrowLabel.isHidden = false
        stackView.addArrangedSubview(arrowLabel)
        
        stackView.addArrangedSubview(UIView())
    }
        
    @objc private func onToggle() {
        print("toggle!")
    }
}
