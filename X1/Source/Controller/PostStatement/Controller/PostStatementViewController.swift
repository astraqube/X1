//
//  PostStatementViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 18/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import ALCameraViewController
import M13Checkbox
import Popover
import CoreLocation

class PostStatementViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var statmentTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postStatementButton: UIButton!
    @IBOutlet weak var viewSimilarStatementButton: UIButton!
    @IBOutlet weak var checkBoxView: M13Checkbox!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var ratingButtonsCollections: [UIButton]!
    @IBOutlet var categoryView: UIView!
    @IBOutlet weak var tagsCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var subcategoryActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet var selectedRatingButtons: [UIButton]!
    @IBOutlet weak var selectTagsCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var selectedExpertLabel: UILabel!
    @IBOutlet var postUrgencyView: UIView!
    @IBOutlet weak var urgencyTableView: UITableView!
    @IBOutlet weak var ratingButtonsStackView: UIStackView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraintCollectioView: NSLayoutConstraint!
    
    
    
    var accessoryView:PostStatmentAccessory!
    var popover:Popover?
    var selectedPriority     = PostUrgency.low
    var selectedLevel        = ExpertLevel.rookie
    var locationManager      = LocationManager()
    var currentLocation:CLLocationCoordinate2D?
    var selectedImages:[UIImage]?
    
    // MARK: - Property
    
    var user:User!
    var hasKeyboardLayoutApplied = false
    let webManager = WebRequestManager()
    var hashtags:[String]?
    var textTagConfig:TTGTextTagConfig  {
        let textConfig = TTGTextTagConfig()
        textConfig.tagSelectedTextColor = UIColor.white
        textConfig.tagTextColor         = UIColor.lightTheme()
        textConfig.tagBackgroundColor   = UIColor.white
        textConfig.tagSelectedBackgroundColor = UIColor.lightTheme()
        return textConfig
    }
    var textTagConfigSelected:TTGTextTagConfig  {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor = UIColor.white
        textConfig.tagBackgroundColor = UIColor.lightTheme()
        return textConfig
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeUI()
        
        // Add notification to observe Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Get user's location first
        weak var weakSelf = self
        locationManager.currentLocation(location: { (latitude, longitude) in
            weakSelf?.currentLocation = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        }) { (isGranted) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // Remove Keyboard observer before it gets deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        postStatementButton.backgroundColor = .clear
        postStatementButton.darkShadow(withRadius: 5)
        postStatementButton.layer.borderWidth = 1.0
        postStatementButton.layer.cornerRadius = 8
        postStatementButton.layer.backgroundColor = UIColor.white.cgColor
        postStatementButton.layer.sublayers?.last?.cornerRadius = 8.0
        postStatementButton.layer.sublayers?.last?.masksToBounds = true
        postStatementButton.layer.borderColor  = UIColor.lightTheme().cgColor
        postStatementButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        postStatementButton.alpha = 0.5
        postStatementButton.isEnabled = false
        
        viewSimilarStatementButton.backgroundColor = .clear
        viewSimilarStatementButton.darkShadow(withRadius: 5)
        viewSimilarStatementButton.layer.borderWidth = 1.0
        viewSimilarStatementButton.layer.backgroundColor = UIColor.white.cgColor
        viewSimilarStatementButton.layer.cornerRadius = 8
        viewSimilarStatementButton.layer.borderColor  = UIColor.lightTheme().cgColor
        viewSimilarStatementButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        
        containerView.backgroundColor = .clear
        containerView.darkShadow(withRadius: 10)
        containerView.layer.backgroundColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 8
        
        setupKeyboardAccesory()
        
        // Setup tags collectionview
        tagsCollectionView.alignment        = .fillByExpandingWidth
        selectTagsCollectionView.alignment  = .center
        selectTagsCollectionView.enableTagSelection = false
        selectTagsCollectionView.scrollDirection    = .horizontal
        tagsCollectionView.delegate         = self
    }
    
    private func setupKeyboardAccesory() {
        // Set Keyboard Accessory
        accessoryView   = PostStatmentAccessory.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        accessoryView.delegate = self
        statmentTextView.inputAccessoryView = accessoryView
    }
    
    // MARK: - Button Action
    
    @IBAction func postStatement(_ sender: Any) {
        // Post statement
        let text = statmentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            return
        }
        popover?.dismiss()
        view.endEditing(true)
        showActivity()
        var parameters:[String: Any] = Dictionary()
        parameters[PostStatementKey.statement] = text
        if selectTagsCollectionView.allTags().count > 0 {
            let tags = selectTagsCollectionView.allTags()
            parameters[PostStatementKey.category] = tags
        }
        parameters[PostStatementKey.expertLevel] = selectedLevel.identifier()
        parameters[PostStatementKey.priority]    = selectedPriority.expirationInterval()
        if let coordinate = currentLocation {
            parameters[PostStatementKey.latitude]  = coordinate.latitude
            parameters[PostStatementKey.longitude] = coordinate.longitude
        }
        parameters[PostStatementKey.location] = PostStatementKey.global
        postStatment(with: parameters, for: user.userId, attachment: selectedImages?.first)
    }
    
    @IBAction func viewSimilarStatement(_ sender: Any) {
    }
    
    @IBAction func closeController(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        // Add image to the question
        view.endEditing(true)
        popover?.dismiss()
        openPhotos()
    }
    
    @IBAction func selectRating(_ sender: UIView) {
        // Show Rating view
        popover?.dismiss()
        if let tag = popover?.tag, tag == sender.tag {
            popover?.tag = -1
            return
        }
        popover = nil
        let options = [
            .type(.up),
            .cornerRadius(5),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.lightGray.withAlphaComponent(0.3)),
            .arrowSize(CGSize.init(width: 10, height: 10))
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover?.tag = sender.tag
        ratingView.frame = CGRect.init(x: 0, y: 0, width: 240, height: 128)
        popover?.show(ratingView, fromView: sender)
        selectedLevel = ExpertLevel(rawValue: sender.tag)!
    }
    
    @IBAction func addCategories(_ sender: UIButton) {
        popover?.dismiss()
        if let tag = popover?.tag, tag == sender.tag {
            popover?.tag = -1
            return
        }
        popover = nil
        let options = [
            .type(.up),
            .cornerRadius(5),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.lightGray.withAlphaComponent(0.3)),
            .arrowSize(CGSize.init(width: 10, height: 10))
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        categoryView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
        popover?.show(categoryView, fromView: sender)
        popover?.tag = sender.tag
        if hashtags == nil {
            requestFetchSubCategory()
        }
    }
    
    @IBAction func addDuration(_ sender: UIButton) {
        popover?.dismiss()
        if let tag = popover?.tag, tag == sender.tag {
            popover?.tag = -1
            return
        }
        popover = nil
        let options = [
            .type(.up),
            .cornerRadius(5),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.lightGray.withAlphaComponent(0.3)),
            .arrowSize(CGSize.init(width: 10, height: 10))
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover?.tag = sender.tag
        postUrgencyView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 200)
        popover?.show(postUrgencyView, fromView: sender)
    }
    
    
    @IBAction func didTapOnEmptyArea(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func selectRatingForPost(_ sender: UIButton) {
        let count = ratingButtonsCollections.count
        for index in 0..<count {
            let isSelected = index <= sender.tag
            let ratingButton         = ratingButtonsCollections[index]
            let selectedRatingButton = selectedRatingButtons[index]
            ratingButton.isSelected = isSelected
            selectedRatingButton.isSelected = isSelected
        }
        if let expertLevel = ExpertLevel(rawValue: sender.tag) {
            let (name, _) = expertLevel.description()
            selectedExpertLabel.text = name
        }
        ratingButtonsStackView.isHidden = false
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        // Remove attachment
        if selectedImages!.count > sender.tag {
            selectedImages?.remove(at: sender.tag)
            let indexPath = IndexPath.init(item: sender.tag, section: 0)
            imageCollectionView.deleteItems(at: [indexPath])
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
}

extension PostStatementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.postUrgencyCell, for: indexPath) as! PostUrgencyTableViewCell
        if let urgency = PostUrgency(rawValue: indexPath.row) {
            let (title, subtitle) = urgency.description()
            tableViewCell.urgencyTitleLabel.text    = title
            tableViewCell.urgencySubTitleLabel.text = subtitle
        }
        tableViewCell.accessoryType = selectedPriority.rawValue == indexPath.row ? .checkmark : .none
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let earlierSelectedCell = tableView.cellForRow(at: IndexPath.init(row: selectedPriority.rawValue, section: 0)) {
            earlierSelectedCell.accessoryType = .none
        }
        let tableViewCell = tableView.cellForRow(at: indexPath) as! PostUrgencyTableViewCell
        tableViewCell.accessoryType = .checkmark
        selectedPriority = PostUrgency(rawValue: indexPath.row)!
        priorityLabel.text = selectedPriority.description().0
        priorityLabel.isHidden    = false
    }
}

extension PostStatementViewController: PostStatmentAccessoryDelegate, UITextViewDelegate {
    
    // MARK: - Keyboard Accessory Delegate
    
    func didSelect(post accessory: PostStatmentAccessory, sender button: UIButton, action type: AttachmentAccesoryType) {
        // Keyboard accesory action detected
        switch type {
        case .image:
            addImage(button)
        case .category:
            addCategories(button)
        case .priority:
            addDuration(button)
        case .rating:
            selectRating(button)
        case .post:
            postStatement(button)
        }
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            postStatementButton.alpha                   = 0.5
            postStatementButton.isEnabled               = false
            placeholderLabel.isHidden                   = false
            accessoryView.postStatementButton.alpha     = 0.5
            accessoryView.postStatementButton.isEnabled = false
            
        }
        else {
            postStatementButton.alpha                   = 1.0
            postStatementButton.isEnabled               = true
            placeholderLabel.isHidden                   = true
            accessoryView.postStatementButton.alpha     = 1.0
            accessoryView.postStatementButton.isEnabled = true
        }
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        return true
    }
    
    // MARK: - Keyboard Notification
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !hasKeyboardLayoutApplied {
                hasKeyboardLayoutApplied = true
                let padding:CGFloat = 10
                let containerViewBottomSpace = self.view.frame.size.height - (containerView.frame.origin.y + containerView.frame.size.height)
                let effectiveInset = keyboardSize.height - containerViewBottomSpace + padding
                textViewHeightConstraint.constant -= effectiveInset
            }
            textViewHeightConstraint.priority = UILayoutPriority(rawValue: 900)
            UIView.animate(withDuration: 0.5) {
                self.containerView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textViewHeightConstraint.priority = UILayoutPriority(rawValue: 500)
        UIView.animate(withDuration: 0.5) {
            self.containerView.layoutIfNeeded()
        }
    }
    
}

// MARK: - Attachment Work

extension PostStatementViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    // MARK: - UICollectionView Datasource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.selectImageCollectionCell, for: indexPath) as! ImageSelectionCollectionViewCell
        imageViewCell.closeButton.tag = indexPath.row
        imageViewCell.imageView.image = selectedImages?[indexPath.row]
        return imageViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 80)
    }
    
    // MARK: - Image Picker
    
    func openPhotos() {
        // Open camera or photos
        let croppingParameters = CroppingParameters.init(isEnabled: true, allowResizing: true, allowMoving: true)
        weak var weakSelf = self
        let cameraController = CameraViewController.init(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { (image, asset) in
            // Dismiss controller
            weakSelf?.dismiss(animated: true, completion: {
                if let selectedImage = image {
                    // If image was selected
                    weakSelf?.didPickImage(image: selectedImage)
                }
            });
        }
        
        present(cameraController, animated: true) {
            
        }
    }
    
    func didPickImage(image:UIImage) {
        // Add the selected image as attachment
       /* let resizedImage = image.resize(byWidth: 200)
        let fullString = NSMutableAttributedString(string: statmentTextView.text + "\n\n")
        fullString.setAttributes([NSAttributedStringKey.font : statmentTextView.font!], range: NSRange.init(location: 0, length: fullString.length))
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect.init(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
         let stringWithAttachment = NSAttributedString(attachment: attachment)
        fullString.append(stringWithAttachment)
        statmentTextView.attributedText = fullString */
        
        if selectedImages == nil {
            selectedImages = Array()
        }
        selectedImages?.append(image)
        heightConstraintCollectioView.priority = UILayoutPriority.init(rawValue: 500)
        imageCollectionView.layoutIfNeeded()
        imageCollectionView.insertItems(at: [IndexPath.init(item: selectedImages!.count-1, section: 0)])
    }
    
    func showActivity() {
        blurView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @objc func showCheckMark() {
        checkBoxView.isHidden = false
        checkBoxView.tintColor = UIColor.darkTheme()
        checkBoxView.animationDuration = 2.0
        checkBoxView.stateChangeAnimation = .stroke
        checkBoxView.setCheckState(.checked, animated: true)
        activityIndicator.stopAnimating()
        perform(#selector(closeView), with: nil, afterDelay: 2.0)
    }
    
    @objc func closeView() {
        dismiss(animated: true) {
            
        }
    }
}

extension PostStatementViewController: TTGTextTagCollectionViewDelegate {
    // MARK: - Tag selection
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        if selected {
            selectTagsCollectionView.addTag(tagText, with: textTagConfigSelected)
        }
        else {
            selectTagsCollectionView.removeTag(tagText)
        }
    }
}

extension PostStatementViewController {
    
    // MARK: - Network Request
    
    private func requestFetchSubCategory() {
        // Fetch categories
        subcategoryActivityIndicator.startAnimating()
        let apiURL = APIURL.url(apiEndPoint: String(APIEndPoint.intersts.dropLast()))
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            // Category fetched
            weakSelf?.didFetchSubCategory(with: response)
            weakSelf?.subcategoryActivityIndicator.stopAnimating()
        }) { (error) in
            // Error in fetching category
            weakSelf?.subcategoryActivityIndicator.stopAnimating()
        }
    }
    
    private func postStatment(with parameters: Dictionary<String, Any>, for principal:String, attachment: UIImage?) {
        // Fetch categories
        let endPoint = APIEndPoint.statement(with: principal)
        let apiURL   = APIURL.statementUrl(apiEndPoint: endPoint)
        weak var weakSelf = self
        webManager.uploadImage(htttpMethod: .post, apiURL: apiURL, parameters: parameters, image: attachment, completion: { (response) in
            // Post created successfully
            weakSelf?.showCheckMark()
        }) { (error) in
            // Error in createing statement
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.blurView.isHidden = true
        }
    }
    
    // MARK: - Request Completion
    
    private func didFetchSubCategory(with response: Dictionary<String, Any>) {
        // Intialize model from response
        if let subcategories = response[APIKeys.result] as? Array<Dictionary<String, Any>> {
            hashtags = Array()
            for categoryInfo in subcategories {
                if let category = Category.init(with: categoryInfo) {
                    hashtags?.append(category.name)
                    
                    // Add tag
                    tagsCollectionView.addTag(category.name.capitalized, with: textTagConfig)
                }
            }
        }
    }
    
}
