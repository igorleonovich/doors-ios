//
//  SessionContentViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

final class SessionContentViewController: BaseSystemFeatureViewController {
    
    private var editorViewController: EditorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialFeatures()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        view.superview?.snp.remakeConstraints { make in
            if let systemControlsSuperview = feature?.dependencies.first(where: { $0.name == "systemControls" })?.viewController?.view.superview {
                make.top.equalTo(systemControlsSuperview.safeAreaLayoutGuide.snp.bottom)
            }
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: Setup
    
    private func setupUI() {
        setupBorders()
        view.backgroundColor = .random().withAlphaComponent(0.5)
    }
    
    private func setupBorders() {
        view.addBorders(color: Color.foregroundActive, width: 1, sides: [.up])
    }
    
    private func loadInitialFeatures() {
        if let feature = feature {
            if let editorFeature = core.rootCore.appManager.featureMap?.startFeatures.first(where: { $0.name == "editor" }),
                editorFeature.isEnabled {
                let sceneFeature = Feature(name: "editor", dependencies: [feature])
                loadChildFeature(sceneFeature)
            }
        }
    }
    
    override func loadChildFeature(_ feature: Feature) {
        super.loadChildFeature(feature)
        switch feature.name {
        case "editor":
            editorViewController = EditorViewController()
            add(child: editorViewController)
        default:
            break
        }
    }
    
    override func unloadFeature(name: String) {
        super.unloadFeature(name: name)
        guard let feature = feature else { return }
        switch feature.name {
        case "editor":
            let editorViewController = EditorViewController()
            add(child: editorViewController)
        default:
            break
        }
    }
}
