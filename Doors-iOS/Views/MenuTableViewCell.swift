//
//  MenuTableViewCell.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 05/03/2024.
//  Copyright © 2024 IL. All rights reserved.
//

import UIKit

class MenuTableViewCell: TableViewCell {
    
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
        
        stackView.addArrangedSubview(UIView())
        
        let toggleButton = Button()
        toggleButton.addTarget(self, action: #selector(onToggle), for: .touchUpInside)
        toggleButton.backgroundColor = .green
        toggleButton.clipsToBounds = true
        toggleButton.layer.cornerRadius = 6
        toggleButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        stackView.addArrangedSubview(toggleButton)
        
        let spacerA = UIView()
        spacerA.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        stackView.addArrangedSubview(spacerA)
        
        titleLabel = Label()
        stackView.addArrangedSubview(titleLabel)
        
        let spacerB = UIView()
        spacerB.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        stackView.addArrangedSubview(spacerB)
        
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
