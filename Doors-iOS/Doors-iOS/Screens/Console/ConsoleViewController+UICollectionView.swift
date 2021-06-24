//
//  ConsoleViewController+UICollectionView.swift
//  Doors-iOS
//
//  Created by Igor Leonovich on 23.06.21
//  Copyright © 2021 FT. All rights reserved.
//

import UIKit
import Rswift

extension ConsoleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = core.userManager.user else { return }
        if indexPath.section == 0 {
            let doorsService = user.doorsServicesActive[indexPath.row]
            switch doorsService {
            case .scene:
                showSceneViewController()
            default:
                break
            }
        } else {
            let doorsService = user.doorsServicesInactive[indexPath.row]
            core.userManager.activateDoorsService(doorsService: doorsService) { [weak self] error in
                guard let `self` = self else { return }
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.core.userManager.getUserProfile { error in
                        if let error = error {
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension ConsoleViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let user = core.userManager.user {
            if section == 0 {
                return user.doorsServicesActive.count
            } else {
                return user.doorsServicesInactive.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = core.userManager.user,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.doorsServiceCell, for: indexPath) else { return UICollectionViewCell() }
        if indexPath.section == 0 {
            cell.configure(with: user.doorsServicesActive[indexPath.row], isActive: true)
        } else {
            cell.configure(with: user.doorsServicesInactive[indexPath.row], isActive: false)
        }
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate

extension ConsoleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topAndBottomIndent: CGFloat = 30.0
        let minimumIndent: CGFloat = 10.0
        let minimumColumnWidth = cellSide + minimumIndent * 2
        let totalColumnsCount = Int(view.bounds.width / minimumColumnWidth)

        let totalCellWidth = cellSide * CGFloat(totalColumnsCount)
        let totalIndentSpace = view.bounds.width - totalCellWidth
        let totalLogicalIndentCount = totalColumnsCount + 1
        let logicalIndentWidth = totalIndentSpace / CGFloat(totalLogicalIndentCount)

        return UIEdgeInsets(top: topAndBottomIndent, left: logicalIndentWidth, bottom: topAndBottomIndent, right: logicalIndentWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
