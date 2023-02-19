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
        
        textView.delegate = self
        textView.layoutManager.delegate = self
        
        putToEditor(list: ListDTO(points: [
            PointDTO(id: UUID(uuidString: UUID.new), userID: UUID(uuidString: UUID.new)!, superPointID: nil, blockID: nil, index: 0, text: "A"),
            PointDTO(id: UUID(uuidString: UUID.new), userID: UUID(uuidString: UUID.new)!, superPointID: nil, blockID: nil, index: 1, text: "B"),
            PointDTO(id: UUID(uuidString: UUID.new), userID: UUID(uuidString: UUID.new)!, superPointID: nil, blockID: nil, index: 2, text: "C"),
            PointDTO(id: UUID(uuidString: UUID.new), userID: UUID(uuidString: UUID.new)!, superPointID: nil, blockID: nil, index: 3, text: "D")
        ]))
    }
    
    private func setupNavigationPanel() {
        navigationItem.title = "Plan"
        let image = UIImage(systemName: "arrow.upright.circle")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(subMenuTapped(_:)))
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
    
    private func setupManager() {
//        if core.sceneManager == nil {
//            let sceneManager = SceneManager()
//            sceneManager.core = core
//            core.sceneManager = sceneManager
//        }
    }
    
    // MARK: - List Actions: Read
    
    private func read() {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        self.core.sceneManager?.read { [weak self] (error, list) in
//            guard let `self` = self else { return }
//            if let error = error {
//                let alert = CustomAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                let okAction = CustomAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//            } else if let list = list {
//                self.putToEditor(list: list)
//            }
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }
        
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

extension PlanViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
//        print(textView.selectedRange)
        print(textView.text(in: textView.selectedTextRange!))
    }
}

extension PlanViewController: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int {
        
        // First, make sure we'll be able to access the NSTextStorage.
        guard let textStorage = layoutManager.textStorage else {
            fatalError("No textStorage was associated to this layoutManager")
        }


        // Access the characters.
        let utf16CodeUnits = textStorage.string.utf16
        var modifiedGlyphProperties = [NSLayoutManager.GlyphProperty]()
        for i in 0 ..< glyphRange.length {
            var glyphProperties = props[i]
            let character = characterFromUTF16CodeUnits(utf16CodeUnits, at: charIndexes[i])

            // Do something with `character`, e.g.:
            if character == "*" {
                glyphProperties.insert(.null)
            }
            
            modifiedGlyphProperties.append(glyphProperties)
        }
            
        // Convert our Swift array to the UnsafePointer `setGlyphs` expects.
        modifiedGlyphProperties.withUnsafeBufferPointer { modifiedGlyphPropertiesBufferPointer in
            guard let modifiedGlyphPropertiesPointer = modifiedGlyphPropertiesBufferPointer.baseAddress else {
                fatalError("Could not get base address of modifiedGlyphProperties")
            }

            // Call setGlyphs with the modified array.
            layoutManager.setGlyphs(glyphs, properties: modifiedGlyphPropertiesPointer, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
        }

        return glyphRange.length
    }
    
    private func characterFromUTF16CodeUnits(_ utf16CodeUnits: String.UTF16View, at index: Int) -> Character {
        let codeUnitIndex = utf16CodeUnits.index(utf16CodeUnits.startIndex, offsetBy: index)
        let codeUnit = utf16CodeUnits[codeUnitIndex]

        if UTF16.isLeadSurrogate(codeUnit) {
            let nextCodeUnit = utf16CodeUnits[utf16CodeUnits.index(after: codeUnitIndex)]
            let codeUnits = [codeUnit, nextCodeUnit]
            let str = String(utf16CodeUnits: codeUnits, count: 2)
            return Character(str)
        } else if UTF16.isTrailSurrogate(codeUnit) {
            let previousCodeUnit = utf16CodeUnits[utf16CodeUnits.index(before: codeUnitIndex)]
            let codeUnits = [previousCodeUnit, codeUnit]
            let str = String(utf16CodeUnits: codeUnits, count: 2)
            return Character(str)
        } else {
            let unicodeScalar = UnicodeScalar(codeUnit)!
            return Character(unicodeScalar)
        }
    }
}
