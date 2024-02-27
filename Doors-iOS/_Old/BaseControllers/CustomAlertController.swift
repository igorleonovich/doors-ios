//
//  CustomAlertController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 26.07.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit

class CustomAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = Color.foregroundActive
        
        let attributes = [
            NSAttributedString.Key.font: OldConstants.Skin.font
        ]
        if let title = title {
            let titleAttributedString = NSMutableAttributedString(string: title, attributes: attributes)
            setValue(titleAttributedString, forKey: "attributedTitle")
        }
        if let message = message {
            let titleAttributedString = NSMutableAttributedString(string: message, attributes: attributes)
            setValue(titleAttributedString, forKey: "attributedMessage")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        actions.forEach { action in
            guard let label = (action.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel,
                  let labelText = label.text else { return }
            let titleAttributedString = NSMutableAttributedString(string: labelText)
            let range = NSRange(location: 0, length: titleAttributedString.length)
            titleAttributedString.addAttribute(NSAttributedString.Key.font, value: OldConstants.Skin.font, range: range)
            label.text = nil
            label.attributedText = titleAttributedString
        }
    }
}

class CustomAlertAction: UIAlertAction {
    
    override var title: String? {
        switch style {
        case .default, .destructive:
            setValue(Color.foregroundActive, forKey: "titleTextColor")
        case .cancel:
            setValue(Color.foregroundInactive, forKey: "titleTextColor")
        @unknown default:
            break
        }
        return super.title
    }
}

