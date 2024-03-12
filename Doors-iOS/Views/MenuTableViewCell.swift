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
    
    var toggleAdditionButton: Button!
    var toggleEnablingButton: Button!
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
        
        toggleAdditionButton = Button()
        toggleAdditionButton.addTarget(self, action: #selector(onToggleAddition), for: .touchUpInside)
        toggleAdditionButton.clipsToBounds = true
        toggleAdditionButton.layer.cornerRadius = 6
        toggleAdditionButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        toggleAdditionButton.imageView?.contentMode = .scaleAspectFit
        toggleAdditionButton.isHidden = true
        stackView.addArrangedSubview(toggleAdditionButton)
        
        toggleEnablingButton = Button()
        toggleEnablingButton.addTarget(self, action: #selector(onToggleEnabling), for: .touchUpInside)
        toggleEnablingButton.clipsToBounds = true
        toggleEnablingButton.layer.cornerRadius = 6
        toggleEnablingButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        toggleEnablingButton.isHidden = true
        stackView.addArrangedSubview(toggleEnablingButton)
        
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
        var toggleAdditionImage = UIImage(named: "Minus")?.withForegroundActiveColor
        toggleAdditionButton.contentEdgeInsets = .init(top: 9, left: 9, bottom: 9, right: 9)
        if isDisabled {
            toggleAdditionImage = UIImage(named: "Plus")?.withForegroundActiveColor
            toggleAdditionButton.contentEdgeInsets = .zero
        }
        toggleAdditionButton.setImage(toggleAdditionImage, for: .normal)
    }
    
    @objc private func onToggleAddition() {
        delegate?.onToggleAddition(index)
    }
    
    @objc private func onToggleEnabling() {
        delegate?.onToggleEnabling(index)
    }
}

protocol MenuTableViewCellDelegate: AnyObject {
    
    func onToggleAddition(_ index: Int)
    func onToggleEnabling(_ index: Int)
}
