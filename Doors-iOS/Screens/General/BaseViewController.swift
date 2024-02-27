//
//  BaseViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 9.05.20.
//  Copyright © 2020 IL. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseFeatureViewController: BaseViewController {
    
    var core: Core!
    var feature: Feature?

    init(core: Core, feature: Feature? = nil) {
        self.core = core
        self.feature = feature
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unloadFeature(name: String) {
        if name == "console" {
            feature?.childFeatures.first(where: { $0.name == "console" })?.viewController?.remove()
            if let indexToRemove = feature?.childFeatures.firstIndex(where: { $0.name == "console" }) {
                feature?.childFeatures.remove(at: indexToRemove)
            }
        }
    }
    
    func loadFeature(_ feature: Feature) {
        if feature.name == "console" {
            let consoleView = UIView()
            view.addSubview(consoleView)
            let consoleViewController = ConsoleViewController(core: core, feature: feature)
            feature.viewController = consoleViewController
            add(child: consoleViewController, containerView: consoleView)
        }
        // [CHECK FOR BUG]
        self.feature?.childFeatures.append(feature)
    }
}

class BaseSystemFeatureViewController: BaseFeatureViewController {
    
    override func loadFeature(_ feature: Feature) {
        super.loadFeature(feature)
        if feature.name == "systemControls" {
            let systemControlsView = UIView()
            view.addSubview(systemControlsView)
            let systemControlsViewController = SystemControlsViewController(core: core, feature: feature)
            feature.viewController = systemControlsViewController
            add(child: systemControlsViewController, containerView: systemControlsView)
        }
        // [CHECK FOR BUG]
        self.feature?.childFeatures.append(feature)
    }
}

class BaseSystemFeatureMenuViewController: BaseSystemFeatureViewController {
    
    var tableView: TableView!
    fileprivate var isNeedToSkipTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundView = BlurView()
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.addBlur()
        setupData()
        setupUI()
        setupGesture()
    }
    
    // MARK: Setup
    
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        tableView = TableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // [WORKAROUND] BaseSystemFeatureMenuViewController: Tap action
        if !UIScreen.isScreenSmall {
            let topButton = UIButton()
            view.addSubview(topButton)
            topButton.snp.makeConstraints { make in
                make.bottom.equalTo(tableView.snp.top)
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
            topButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        }
        
        let bottomButton = UIButton()
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        bottomButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        gesture.delegate = self
        tableView.addGestureRecognizer(gesture)
    }
    
    func setupData() {}
    
    
    // MARK: Update
    
    func updateHeight(contentHeight: CGFloat) {
        view.layoutIfNeeded()
        var offset: CGFloat = 0
        if contentHeight > view.bounds.height {
            offset = view.bounds.height
            tableView.contentInset = .init(top: 100, left: 0, bottom: 100, right: 0)
            tableView.contentOffset = CGPoint(x: 0, y: -100)
        } else {
            offset = contentHeight
            tableView.contentInset = .zero
            tableView.contentOffset = .zero
        }
        tableView.snp.updateConstraints { make in
            make.height.equalTo((offset))
        }
    }
    
    // MARK: Actions
    
    @objc private func onTap() {
        // [WORKAROUND] BaseSystemFeatureMenuViewController: Tap action
        if !UIScreen.isScreenSmall {
            onClose()
        } else {
            if !isNeedToSkipTap {
                onClose()
            } else {
                isNeedToSkipTap = false
            }
        }
    }
    
    func onClose(_ completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}

extension BaseSystemFeatureMenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var result = true
        tableView.subviews.forEach { subview in
            if let subview = subview as? BaseTableViewCell {
                let value = subview.titleLabel.point(inside: touch.location(in: subview.titleLabel), with: nil)
                if value {
                    result = false
                }
            }
        }
        // [WORKAROUND] BaseSystemFeatureMenuViewController: Tap action
        if UIScreen.isScreenSmall {
            isNeedToSkipTap = true
        }
        return result
    }
}
