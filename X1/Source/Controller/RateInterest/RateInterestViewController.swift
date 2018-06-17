//
//  RateInterestViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 17/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Whisper

class RateInterestViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var bucketView: UIView!
    @IBOutlet weak var expertiseTypeLabel: UILabel!
    @IBOutlet weak var expertiseTypeSubtitleLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var draggableLabel: PaddedLabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedTagLabel: UILabel!
    @IBOutlet var ratingButtons: [UIButton]!
    
    // MARK: - Other Property
    
    var selectedInterests:[Category]!
    var user:User!
    var selectedIndex:Int?
    var selectedTag:Category?
    var draggedCategories:Dictionary<ExpertLevel, [Category]> = Dictionary()
    var selectedExpertLevel = ExpertLevel.rookie
    var selectedTagLabelCenter:CGPoint!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedTagLabelCenter = selectedTagLabel.center
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Customize button as per them appearnace
        rateButton.backgroundColor = .clear
        rateButton.darkShadow(withRadius: 5)
        rateButton.layer.borderWidth = 1.0
        rateButton.layer.backgroundColor = UIColor.white.cgColor
        rateButton.layer.cornerRadius = 8
        rateButton.layer.borderColor  = UIColor.lightTheme().cgColor
        rateButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        
        selectedTagLabel.textColor                = .white
        selectedTagLabel.backgroundColor          = UIColor.clear
        selectedTagLabel.layer.backgroundColor    = UIColor.lightTheme().cgColor
        selectedTagLabel.layer.cornerRadius       = 2
        selectedTagLabel.darkShadow(withRadius: 4)
        
        // Setup Tag View
        tagCollectionView.enableTagSelection = true
        displayTag()
        
        // Add a pan gesture to SuperView
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(didRecognizePan(sender:)))
        tagCollectionView.addGestureRecognizer(panGesture)
        
        let dragBackPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(didDragTagLabel(sender:)))
        self.selectedTagLabel.addGestureRecognizer(dragBackPanGesture)
        self.selectedTagLabel.isUserInteractionEnabled = true
    }
    
    private func showAlert(title: String, message: String) {
        // Show alert to user
        let announcement = Announcement(title: title, subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
            
        })
    }
    
    private func displayTag() {
        // Set selected tags
        tagCollectionView.backgroundColor = .white
        let count = selectedInterests.count
        
        draggableLabel.textColor                = .white
        draggableLabel.backgroundColor          = UIColor.clear
        draggableLabel.layer.backgroundColor    = UIColor.lightTheme().cgColor
        draggableLabel.layer.cornerRadius       = 2
        draggableLabel.darkShadow(withRadius: 4)
        
        for index in 0..<count {
            let tag = selectedInterests[index]
            tagCollectionView.addTag(tag.name, with: textConfig)
        }
        
        tagCollectionView.scrollDirection       = .horizontal
        tagCollectionView.numberOfLines         = tagCollectionView.intrinsicContentSize.height > 40 ? 2 : 1
        tagCollectionView.alignment             = .fillByExpandingWidth
        print("Intrinsic size \(tagCollectionView.intrinsicContentSize)")
    }
    
    private func setupDraggableView(for tag: Category, at point: CGPoint) {
        draggableLabel.text = tag.name
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
            let touchPoint  = sender.location(in: pickerView)
            if touchPoint.x > 0 && touchPoint.y > 0 && touchPoint.x <= pickerView.frame.size.width && touchPoint.y <= pickerView.frame.size.height {
                // Tag is dragged to Bucketview
                var expertCategories = draggedCategories[selectedExpertLevel]
                if expertCategories == nil {
                    expertCategories = Array()
                }
                expertCategories?.insert(tag, at: 0)
                draggedCategories[selectedExpertLevel] = expertCategories
                pickerView.selectRow(0, inComponent: 0, animated: true)
                pickerView.isHidden = false
                pickerView.reloadComponent(0)
                selectedTagLabel.text = tag.name
                selectedTagLabel.isHidden = false
            }
            else {
                // Add back to TagCollection
                selectedInterests.append(tag)
                tagCollectionView.addTag(tag.name, with: textConfig)
            }
            selectedTag = nil
            selectedIndex = nil
            draggableLabel.isHidden = true
        default:
            break
        }
    }
    
    @objc private func didDragTagLabel(sender: UIPanGestureRecognizer) {
        guard !selectedTagLabel.isHidden else {
            return
        }
        switch sender.state {
        case .began:
            // Remove the tag from Picker view and
            var selectedCategory = draggedCategories[selectedExpertLevel]
            let selectedRow   = pickerView.selectedRow(inComponent: 0)
            selectedTag       = selectedCategory?.remove(at: selectedRow)
            draggedCategories[selectedExpertLevel] = selectedCategory
            pickerView.reloadComponent(0)
            break
        case .changed:
            // Translate view
            let translation = sender.translation(in: view)
            sender.setTranslation(CGPoint.zero, in: view)
            selectedTagLabel.center = CGPoint(x: selectedTagLabel.center.x+translation.x, y: selectedTagLabel.center.y+translation.y)
        case .ended:
            // Select another label
            selectedTagLabel.center = selectedTagLabelCenter
            guard let tag = selectedTag, var selectedCategory = draggedCategories[selectedExpertLevel] else {
                return
            }
            let touchPoint  = sender.location(in: tagCollectionView)
            if touchPoint.x <= tagCollectionView.frame.size.width && touchPoint.y <= tagCollectionView.frame.size.height {
                // Successfully dragged back
                if selectedCategory.count > 0 {
                    selectedTagLabel.text = selectedCategory[0].name
                }
                else {
                    pickerView.isHidden       = true
                    selectedTagLabel.isHidden = true
                }
                selectedInterests.append(tag)
                // Add tag
                tagCollectionView.addTag(tag.name, with: textConfig)
            }
            else if !selectedCategory.contains(tag) {
                // Failed to drag
                selectedCategory.insert(tag, at: 0)
                selectedTagLabel.text = selectedCategory[0].name
                draggedCategories[selectedExpertLevel] = selectedCategory
                refreshPickerView()
            }
        default:
            break
        }
    }
    
    // MARK: - IB Action
    
    @IBAction func saveSelectedRatings(_ sender: Any) {
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingChanged(_ sender: UIButton) {
        selectedExpertLevel = ExpertLevel(rawValue: sender.tag)!
        refreshPickerView()
        for  ratingButton in ratingButtons {
            ratingButton.isSelected = sender.tag >= ratingButton.tag
        }
        let rating                      = ExpertLevel(rawValue: sender.tag)!
        let (name, subtitle)            = rating.description()
        expertiseTypeLabel.text         = name
        expertiseTypeSubtitleLabel.text = subtitle
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let ratingOverviewViewController = segue.destination as? RatingOverviewViewController {
            ratingOverviewViewController.draggedCategories = draggedCategories
            ratingOverviewViewController.user              = user
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tagCollectionView.allTags().count > 0 {
            // Tags are there to be rated
            showAlert(title: NSLocalizedString("chooseExpertLevelTitle", comment: ""), message: NSLocalizedString("chooseExpertLevelMessage", comment: ""))
            return false
        }
        return true
    }
}


extension RateInterestViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func refreshPickerView() {
        let count = draggedCategories[selectedExpertLevel]?.count ?? 0
        if count == 0 {
            pickerView.isHidden = true
            selectedTagLabel.isHidden = true
        }
        else if let selectedCategories = draggedCategories[selectedExpertLevel] {
            pickerView.isHidden       = false
            selectedTagLabel.isHidden = false
            selectedTagLabel.text     = selectedCategories[0].name
        }
        pickerView.reloadComponent(0)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return draggedCategories[selectedExpertLevel]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return draggedCategories[selectedExpertLevel]![row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedCategory = draggedCategories[selectedExpertLevel], selectedCategory.count > row {
            selectedTagLabel.text = selectedCategory[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel!
        if let textLabel = view as? UILabel {
            label = textLabel
        }
        else {
            label = UILabel()
            label.font = UIFont.robotoFont(wityType: .regular, size: 16)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment             = .center
        }
        if let selectedCategory = draggedCategories[selectedExpertLevel] {
            label.text = selectedCategory[row].name
        }
        return label
    }
}
