//
//  String+Extensions.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 3.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

extension String {
    
    func localized(tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, comment: "")
    }
    
    func gapped() -> String {
        self.map({ String($0) + " " }).joined()
    }
}
