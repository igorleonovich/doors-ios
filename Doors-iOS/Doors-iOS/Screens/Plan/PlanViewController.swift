//
//  PlanViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 24.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit
import MBProgressHUD

class PlanViewController: BaseNavigableViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationPanel()
        setupManager()
    }
    
    private func setupNavigationPanel() {
        navigationItem.title = "Plan"
        let image = UIImage(systemName: "arrow.upright.circle")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(subMenuTapped(_:)))
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
    
    private func setupManager() {
        if core.sceneManager == nil {
            let sceneManager = SceneManager()
            sceneManager.core = core
            core.sceneManager = sceneManager
        }
    }
    
    // MARK: - List Actions: Read
    
    private func read() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.core.sceneManager?.read { [weak self] (error, list) in
            guard let `self` = self else { return }
            if let error = error {
                let alert = CustomAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = CustomAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else if let list = list {
                self.putToEditor(list: list)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func putToEditor(list: ListDTO) {
        var text = ""
        list.points.forEach { point in
            if let pointID = point.id {
                text += "<!--\(pointID)-->\n"
            }
            text += "* \(point.text)\n"
        }
        self.textView.text = text
    }
    
    // MARK: - List Actions: Write
    
    private func write() {
        let lines = textView.text?.components(separatedBy: "/n")
        lines?.forEach { line in
            
        }
    }
    
    // MARK: - Sub Menu Actions
    
    @objc func subMenuTapped(_ sender: Any) {
        let optionMenu = CustomAlertController(title: nil, message: "Sub Menu", preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        let readAction = CustomAlertAction(title: "Read", style: .default, handler: { [weak self] action in
            guard let `self` = self else { return }
            self.read()
        })
        let writeAction = CustomAlertAction(title: "Write", style: .default, handler: { [weak self] action in
            guard let `self` = self else { return }
            self.write()
        })
        let cancelAction = CustomAlertAction(title: "Cancel", style: .cancel)
        [readAction, writeAction, cancelAction].forEach { optionMenu.addAction($0) }
        self.parent?.present(optionMenu, animated: true, completion: nil)
    }
}
