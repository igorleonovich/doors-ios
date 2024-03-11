//
//  StartScreenViewController.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 4.02.23.
//  Copyright © 2023 IL. All rights reserved.
//

import UIKit

final class StartScreenViewController: BaseSystemFeatureMenuViewController {

    private var features = [UserFeature]()
    
    // MARK: Setup
    
    override func setupData() {
        super.setupData()
        if let startFeatures = core.rootCore.appManager.featureMap?.startFeatures {
            features = startFeatures
        }
    }
    
    override func setupUI() {
        super.setupUI()
        updateHeight(contentHeight: CGFloat(features.count * Int(FeatureCell.height)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeatureCell.self, forCellReuseIdentifier: "FeatureCell")
    }
}

extension StartScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeatureCell.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TableViewCell)?.isDisabled = !features[indexPath.row].isAdded
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feature = feature else { return }
        let startScreenFeature = Feature(name: "startScreen", dependencies: feature.dependencies)
        let startScreenViewController = StartScreenViewController(core: core, feature: startScreenFeature)
        startScreenFeature.viewController = startScreenViewController
        
        navigationController?.pushViewController(startScreenViewController, animated: false)
    }
}

extension StartScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureCell {
            cell.configure(feature: features[indexPath.row])
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension StartScreenViewController: MenuTableViewCellDelegate {
    
    func onToggleAddition(_ index: Int) {
        switch features[index].name {
        case "import":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let importFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "import") {
                        (importFeature.viewController as? ImportViewController)?.run()
                        onBack() {
                            (importFeature.viewController as? ImportViewController)?.run()
                        }
                    }
                }
            }
        case "export":
            if let systemControlsFeature = feature?.dependencies.first(where: { $0.name == "start" })?.dependencies.first(where: { $0.name == "systemControls" }) {
                if let rootSessionFeature = systemControlsFeature.dependencies.first(where: { $0.name == "rootSession" }) {
                    if let exportFeature = (rootSessionFeature.viewController as? RootSessionViewController)?.makeChildFeature(name: "export") {
                        onBack() {
                            (exportFeature.viewController as? ExportViewController)?.run()
                        }
                    }
                }
            }
        case "reset":
            print("\n[TODO] [RESET] Do you really want to reset current user?")
            try? core.rootCore.fileSystemManager.removeFile(fileName: "Doors", fileFormat: "")
            UIApplication.rootViewController?.reloadRootSesion()
        default:
            break
        }
    }
    
    func onToggleEnabling(_ index: Int) {
        
    }
}

final class FeatureCell: MenuTableViewCell {
    
    static let height: CGFloat = 50
    
    func configure(feature: UserFeature) {
        toggleAdditionButton.isHidden = false
        toggleEnablingButton.isHidden = false
        toggleEnablingButton.backgroundColor = feature.isEnabled ? .green : .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        titleLabel.text = feature.title?.localized(tableName: "Feature")
        arrowLabel.isHidden = feature.childFeatures?.isEmpty ?? true
    }
}
