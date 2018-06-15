
//
//  ChooseInterestViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 03/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import Whisper

class ChooseInterestViewController: UIViewController {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var carouselFlowLayout: UPCarouselFlowLayout!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var subcategoryView: Subcategory!
    @IBOutlet weak var pickInterestView: PickInterest!
    @IBOutlet weak var categoryActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subcategoryActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraintCategoryView: NSLayoutConstraint!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var heightConstraintSubcategoryView: NSLayoutConstraint!
    @IBOutlet weak var subcategoryContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Other Property
    
    let webManager = WebRequestManager()
    var itemSize:CGSize!
    var isProcessing = false
    var categories:Array<Category>?
    var selectedCategory:Category!
    var selectedSubcategories:[Category] = Array()
    var selectedTags:[Category] = Array()
    var user:User!
    var isDisplayingCategoryInFull = true
    var isDisplayingSubCategoryInFull = true

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize UI
        customizeUI()
        
        // Fetch categories
        requestFetchCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Do any additional setup after loading the view.
        carouselFlowLayout.scrollDirection = .horizontal
        var size    = categoryCollectionView.frame.size
        size.width  = size.width/2.3
        size.height -= 5
        carouselFlowLayout.itemSize = size
        carouselFlowLayout.spacingMode = .fixed(spacing: 10)
        
        // Set shadow
        subcategoryView.darkShadow(withRadius: 2)
        subcategoryView.delegate = self
        updateButton.darkShadow(withRadius: 8)
        
        
        // Customize button 
        updateButton.backgroundColor = .clear
        updateButton.darkShadow(withRadius: 5)
        updateButton.layer.borderWidth = 1.0
        updateButton.layer.backgroundColor = UIColor.white.cgColor
        updateButton.layer.cornerRadius = 8
        updateButton.layer.borderColor  = UIColor.lightTheme().cgColor
        updateButton.setTitleColor(UIColor.darkTheme(), for: .normal)
    }
    
    private func showAlert(title: String, message: String) {
        // Show alert to user
        let announcement = Announcement(title: title, subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
            
        })
    }
    
    // MARK: - IB Action

    @IBAction func updateCategory(_ sender: Any) {
        if user.type == .principal {
            // For Principal
            if selectedSubcategories.count == 0 {
                // Ask user to select subcategories
                showAlert(title: NSLocalizedString("selectSubcategoriesTitle", comment: ""), message: NSLocalizedString("selectSubcategoriesMessage", comment: ""))
            }
            else {
                // Update selected interests
                var selectedInterests:[String] = Array()
                for subcategory in selectedSubcategories {
                    selectedInterests.append(subcategory.name)
                }
                let parameters = [APIKeys.categoryName: selectedInterests]
                requestUpdateInterests(with: parameters, principle: user.userId)
            }
            
        }
        else {
            // For resource and other types of users
            if selectedSubcategories.count == 0 || selectedTags.count == 0 {
                // Ask user to select subcategories and tags
                showAlert(title: NSLocalizedString("selectSubcategoriesTitle", comment: ""), message: NSLocalizedString("selectSubcategoriesMessage", comment: ""))
            }
            else {
                gotoSelectRatingScreen()
            }
            
        }
    }
    
    // MARK: - Expand Collapse Category/Subcategory
    
    private func toggleCategory(full display: Bool) {
        if display {
            heightConstraintCategoryView.priority = UILayoutPriority(rawValue: 500)
            carouselFlowLayout.itemSize.height = 195
        }
        else {
            heightConstraintCategoryView.priority = UILayoutPriority(rawValue: 900)
            carouselFlowLayout.itemSize.height = 50
        }
        UIView.animate(withDuration: 0.5) {
            self.categoryContainerView.layoutIfNeeded()
        }
        isDisplayingCategoryInFull = display
        categoryCollectionView.reloadData()
    }
    
    private func toggleSubcategory(full display: Bool) {
        if display {
            heightConstraintSubcategoryView.priority = UILayoutPriority(rawValue: 500)
        }
        else {
            heightConstraintSubcategoryView.priority = UILayoutPriority(rawValue: 900)
        }
        UIView.animate(withDuration: 0.5) {
            self.subcategoryContainerView.layoutIfNeeded()
        }
        isDisplayingSubCategoryInFull = display
        subcategoryView.refreshLayout(isFull: display)
    }
    
    // MARK: - Navigation
    
    private func gotToLetsBeginScreen() {
        // Let's Begin Screen for Principal
        let letsBeginViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.letsBegin) as! LetsBeginViewController
        letsBeginViewController.user = user
        navigationController?.pushViewController(letsBeginViewController, animated: true)
    }
    
    private func gotoSelectRatingScreen() {
        // Rating screen for resource
        let rateIntererstViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.rateInterest) as! RateInterestViewController
        rateIntererstViewController.user = user
        rateIntererstViewController.selectedInterests = selectedTags
        navigationController?.pushViewController(rateIntererstViewController, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}

extension ChooseInterestViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ChooseInterestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.selectCategoryCell, for: indexPath) as! InterestCategoryCollectionViewCell
        if let category = categories?[indexPath.row] {
            // Configure cell
            categoryCell.categoryTitleLabel.text = category.name.capitalized
            categoryCell.containerView.layer.cornerRadius = isDisplayingCategoryInFull ? 40 : 2
            if let imageURL = category.imageURL {
                categoryCell.categoryImageView.setImage(withURL: imageURL, placeholder: nil)
            }
        }
        return categoryCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Reload all categories
        reloadSubcategory(categories: false)
        toggleSubcategory(full: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDisplayingCategoryInFull {
            toggleCategory(full: true)
            toggleSubcategory(full: true)
            reloadSubcategory(categories: false)
        }
    }
}

extension ChooseInterestViewController: SubcategoryDelegate {
    
    // MARK: - Reload Subcategory
    
    private func reloadSubcategory(categories selected: Bool) {
        if selected {
            // When collapsed, only selected categories will be displayed
            subcategoryView.reloadSubcategory(with: selectedSubcategories)
        }
        else {
            // Get the visible cells for collection view here and find out the middle one
            let selectedRow = categoryCollectionView.centerCellIndexPath!.item
            
            // Cancel the previous subcategory fetch request to avoid too many requests if user is scrolling too fast
            isProcessing = false
            webManager.cancelLastRequset()
            
            if  let category = categories?[selectedRow] {
                selectedCategory = category
                subcategoryView.datasource = selectedCategory.subcategories
                subcategoryView.reloadSubcategory(with: selectedCategory.subcategories)
                if selectedCategory.subcategories == nil || selectedCategory.subcategories!.count == 0 {
                    // Subcatogies will only be fetched only once during the lifetime of the app
                    requestFetchSubCategory(for: category.identifier)
                }
            }
        }
    }
    
    // MARK: - Subcateogy Delegate
    
    func didSelect(subcategory: Subcategory, item: Category, selected: Bool) {
         // Subcategory selected or deselected
        let offset:CGFloat = 110
        if selected {
            selectedSubcategories.insert(item, at: 0)
            containerViewHeightConstraint.constant += offset
        }
        else if let index = selectedSubcategories.index(of: item) {
            selectedSubcategories.remove(at: index)
            containerViewHeightConstraint.constant -= offset
            
            // Remove selected third level of categories for this sucategory
            if selectedTags.count > 0 {
                selectedTags = selectedTags.filter{$0.superIdentifier! != item.identifier}
            }
        }
        
        if user.type != .principal {
            toggleCategory(full: false)
        }
        
        if !isDisplayingSubCategoryInFull {
            toggleSubcategory(full: true)
        }
        
        if user.type != .principal {
            // If user type is resource or both
            pickInterestView.setInterest(for: selectedSubcategories)
            pickInterestView.delegate = self
            self.containerView.updateConstraints()
            self.scrollView.layoutIfNeeded()
            scrollView.scrollRectToVisible(containerView.bounds, animated: true)
        }
    }
    
    func shouldExpand(subcatgory: Subcategory) {
        reloadSubcategory(categories: false)
        toggleSubcategory(full: true)
    }
}

extension ChooseInterestViewController: InterestSelectionDelegate {
    
    // MARK: - Tag Selection Delegate
    
    func didSelect(in subcategory: Category, for tag: Category, selected: Bool) {
        // Tag selected
        tag.isSelected = selected
        reloadSubcategory(categories: true)
        toggleSubcategory(full: false)
        if selected {
            selectedTags.append(tag)
        }
        else if let index  = selectedTags.index(of: tag) {
            selectedTags.remove(at: index)
        }
    }
}

extension ChooseInterestViewController {
    
    // MARK: - Network Request
    
    private func requestFetchCategory() {
        // Fetch categories
        guard !isProcessing else {
            return
        }
        categoryActivityIndicator.startAnimating()
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.category)
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            // Category fetched
            weakSelf?.didFetchCategory(with: response)
            weakSelf?.isProcessing = false
            weakSelf?.categoryActivityIndicator.stopAnimating()
        }) { (error) in
            // Error in fetching category
            weakSelf?.isProcessing = false
            weakSelf?.categoryActivityIndicator.stopAnimating()
        }
    }
    
    private func requestFetchSubCategory(for category: String) {
        // Fetch categories
        guard !isProcessing else {
            return
        }
        subcategoryActivityIndicatorView.startAnimating()
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.subcategory) + category
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            // Category fetched
            weakSelf?.didFetchSubCategory(with: response, for: category)
            weakSelf?.isProcessing = false
            weakSelf?.subcategoryActivityIndicatorView.stopAnimating()
        }) { (error) in
            // Error in fetching category
            weakSelf?.isProcessing = false
            weakSelf?.subcategoryActivityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Request Completion
    
    private func didFetchCategory(with response: Dictionary<String, Any>) {
        // Intialize model from response
        if let categories = response[APIKeys.result] as? Array<Dictionary<String, Any>> {
            self.categories = Array()
            for categoryInfo in categories {
                if let category = Category.init(with: categoryInfo) {
                    self.categories?.append(category)
                }
            }
            
            // Reload categories
            categoryCollectionView.reloadData()
            if categoryCollectionView.numberOfItems(inSection: 0) > 1 {
                categoryCollectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredHorizontally, animated: true)
                // Find subcategory for second (centered) category
                selectedCategory = self.categories![1]
                requestFetchSubCategory(for: selectedCategory.identifier)
            }
            else if categories.count > 0 {
                // Find subcategory for first category in case not more than 1 category is available
                selectedCategory = self.categories!.first
                requestFetchSubCategory(for: selectedCategory.identifier)
            }
        }
    }
    
    private func didFetchSubCategory(with response: Dictionary<String, Any>, for category: String) {
        // Intialize model from response
        guard selectedCategory.identifier == category else {
            return
        }
        if let subcategories = response[APIKeys.result] as? Array<Dictionary<String, Any>> {
            selectedCategory.subcategories = Array()
            for categoryInfo in subcategories {
                if let category = Category.init(with: categoryInfo) {
                    selectedCategory.subcategories?.append(category)
                }
            }
            subcategoryView.datasource = selectedCategory.subcategories
            subcategoryView.reloadSubcategory(with: selectedCategory.subcategories)
        }
    }
    
}

extension ChooseInterestViewController {
    
    // MARK: - Network Request
    
    private func requestUpdateInterests(with parameters: Dictionary<String, Any>, principle identifier: String) {
        // Update Skill Sets wrt expert level
        activityIndicator.startAnimating()
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.updateInterest +  identifier)
        weak var weakSelf = self
        webManager.httpRequest(method: .post, apiURL: apiURL, body: parameters, completion: { (response) in
            // Move to next screen when ratings are saved.
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.gotToLetsBeginScreen()
        }) { (error) in
            // Failed to update categories
            weakSelf?.activityIndicator.stopAnimating()
        }
    }
    
}
