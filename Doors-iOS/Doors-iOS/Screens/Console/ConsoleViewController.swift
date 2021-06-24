//
//  ConsoleViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 5/9/20.
//  Copyright © 2020 FT. All rights reserved.
//

import UIKit
import MBProgressHUD
import Rswift

class ConsoleViewController: BaseNavigableViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellSide: CGFloat = 100.0
    let cellSize = CGSize(width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Console"
        collectionView.register(R.nib.doorsServiceCell)
        core.userManager.getUserProfile { error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Navigation
    
    func showSceneViewController() {
        let sceneViewController = SceneViewController(core: core)
        navigationController?.pushViewController(sceneViewController, animated: true)
    }
}
