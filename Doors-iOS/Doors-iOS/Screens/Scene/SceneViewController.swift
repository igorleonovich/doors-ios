//
//  SceneViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 24.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit

class SceneViewController: BaseNavigableViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Scene"
    }
    
}
