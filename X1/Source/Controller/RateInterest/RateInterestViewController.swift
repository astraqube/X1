//
//  RateInterestViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 17/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RateInterestViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var bucketView: UIView!
    @IBOutlet weak var expertiseTypeLabel: UILabel!
    @IBOutlet weak var expertiseTypeSubtitleLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var draggableLabel: PaddedLabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Other Property
    
    var selectedInterests:[Category]!
    var user:User!
    var selectedIndex:Int?
    var selectedTag:Category?
    var draggedCategories:[Category] = Array()
    var textConfig:TTGTextTagConfig {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor                 = .white
        textConfig.tagBackgroundColor           = UIColor.lightTheme()
        textConfig.tagSelectedTextColor         = .white
        textConfig.tagSelectedBackgroundColor   = UIColor.lightTheme()
        return textConfig
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Customize button as per them appearnace
        rateButton.backgroundColor = .white
        rateButton.darkShadow(withRadius: 10)
        rateButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        rateButton.layer.sublayers?.last?.cornerRadius = 7.0
        rateButton.layer.sublayers?.last?.masksToBounds = true
        
        // Setup Tag View
        tagCollectionView.enableTagSelection = true
        displayTag()
        
        // Add a pan gesture to SuperView
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(didRecognizePan(sender:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func displayTag() {
        // Set selected tags
        tagCollectionView.backgroundColor = .white
        let count = selectedInterests.count
        draggableLabel.textColor                = .white
        draggableLabel.backgroundColor          = UIColor.lightTheme()
        draggableLabel.darkShadow(withRadius: 4)
        for index in 0..<count {
            let tag = selectedInterests[index]
            tagCollectionView.addTag(tag.name.capitalized, with: textConfig)
        }
    }
    
    private func setupDraggableView(for tag: Category, at point: CGPoint) {
        draggableLabel.text = tag.name.capitalized
        let width = tag.name.widthOfString(usingFont: draggableLabel.font) + 16
        var frame = draggableLabel.frame
        frame.size.width = width
        draggableLabel.frame = frame
        draggableLabel.center = point
    }
    
    // MARK: - Gesture Recognizer
    
    @objc private func didRecognizePan(sender: UIPanGestureRecognizer) {
        
        draggableLabel.isMultipleTouchEnabled = true
        draggableLabel.isUserInteractionEnabled = true
        
        switch sender.state {
        case .began:
            // Get selected tag
            let selectedPoint = sender.location(in: tagCollectionView)
            let index = tagCollectionView.indexOfTag(at: selectedPoint)
            if selectedInterests.count > index {
                let tag = selectedInterests[index]
                let touchPoint  = sender.location(in: view)
                draggableLabel.isHidden = false
                setupDraggableView(for: tag, at: touchPoint)
                draggableLabel.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
                tagCollectionView.removeTag(at: UInt(index))
                selectedInterests.remove(at: index)
                selectedIndex = index
                selectedTag   = tag
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .curveEaseInOut , animations: {
                    self.draggableLabel.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }) { (status) in
                    
                }
            }
        case .changed:
            let translation = sender.translation(in: view)
            sender.setTranslation(CGPoint.zero, in: view)
            draggableLabel.center = CGPoint(x: draggableLabel.center.x+translation.x, y: draggableLabel.center.y+translation.y)
        case .ended:
            guard let tag = selectedTag else {
                return
            }
            let touchPoint  = sender.location(in: bucketView)
            if touchPoint.x > 0 && touchPoint.y > 0 {
                // Tag is dragged to Buckerview
                draggedCategories.insert(tag, at: 0)
                pickerView.reloadAllComponents()
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                // Add back to TagCollection
                selectedInterests.append(tag)
                tagCollectionView.addTag(tag.name.capitalized, with: textConfig)
            }
            selectedTag = nil
            selectedIndex = nil
            draggableLabel.isHidden = true
        case .failed:
            break
        default:
            break
        }
    }
    
    @objc private func longPressGesture(sender: UIGestureRecognizer) {
        
    }
    
    // MARK: - IB Action
    
    @IBAction func saveSelectedRatings(_ sender: Any) {
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.

    }

}



extension RateInterestViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return draggedCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return draggedCategories[row].name.capitalized
    }
}
