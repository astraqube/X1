
//
//  ChooseInterestViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 03/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class ChooseInterestViewController: UIViewController {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var carouselFlowLayout: UPCarouselFlowLayout!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var subcategoryView: Subcategory!
    @IBOutlet weak var categoryActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subcategoryActivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Other Property
    
    let webManager = WebRequestManager()
    var itemSize:CGSize!
    var isProcessing = false
    var categories:Array<Category>?
    var selectedCategory:Category!
    var user:User!

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
        updateButton.darkShadow(withRadius: 8)
        
        // Set border
        updateButton.layer.borderColor   = UIColor.lightTheme().cgColor
        updateButton.layer.borderWidth   = 1.0
    }
    
    // MARK: - IB Action

    @IBAction func updateCategory(_ sender: Any) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let letsBeginViewController = segue.destination as? LetsBeginViewController {
            letsBeginViewController.user = user
        }
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
            if let imageURL = category.imageURL {
                categoryCell.categoryImageView.setImage(withURL: imageURL, placeholder: nil)
            }
            
        }
        return categoryCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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

extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
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
