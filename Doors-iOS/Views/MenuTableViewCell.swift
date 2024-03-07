//
//  MenuTableViewCell.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 05/03/2024.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

class MenuTableViewCell: TableViewCell {
    
    weak var delegate: MenuTableViewCellDelegate?
    
    var toggleButton: Button!
    var titleLabel: Label!
    var arrowLabel: Label!
    var index = 0
    
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
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
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
        arrowLabel.isHidden = true
        stackView.addArrangedSubview(arrowLabel)
        
        stackView.addArrangedSubview(UIView())
    }
    
    // MARK: Actions
    
    override func applyIsDisabledState() {
        super.applyIsDisabledState()
        toggleButton.backgroundColor = isDisabled ? .gray : .green
    }
    
    @objc private func onToggle() {
        delegate?.onToggle(index)
    }
}

protocol MenuTableViewCellDelegate: AnyObject {
    
    func onToggle(_ index: Int)
}
