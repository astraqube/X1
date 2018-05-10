//
//  Subcategory.swift
//  Solviant
//
//  Created by Rohit Kumar on 04/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class Subcategory: UIView {

    // MARK: - IB Outlet
    
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    var datasource:Array<Category>?
    private let cellSize = CGSize.init(width: 100, height: 60)
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK: - Other Property
    
    weak var delegate:SubcategoryDelegate?
    var isFullDisplay = true
    var lastSelectedRow:Int!
    
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let subcategoryView = Bundle.main.loadNibNamed("Subcategory", owner: self, options: [:])?.first as? UIView {
            subcategoryView.frame = self.bounds
            self.addSubview(subcategoryView)
            
            // Register cell
            registerCell(with: ReusableIdentifier.subcategoryCell)
            
        }
        
    }
    
    // MARK: - Utility
    
    private func registerCell(with Identifer: String) {
        subcategoryCollectionView.register(UINib.init(nibName: "SubcategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: Identifer)
    }
    
    private func setSelection(at indexPath: IndexPath) {
        if let subcategory = datasource?[indexPath.row] {
            subcategory.isSelected = !subcategory.isSelected
            lastSelectedRow = indexPath.row
            if let subcategoryCollectionViewCell = subcategoryCollectionView.cellForItem(at: indexPath)  as? SubcategoryCollectionViewCell {
                if subcategory.isSelected {
                    subcategoryCollectionViewCell.subcategoryTitleLabel.backgroundColor = UIColor.darkTheme()
                    subcategoryCollectionViewCell.subcategoryTitleLabel.textColor       = .white
                }
                else {
                    subcategoryCollectionViewCell.subcategoryTitleLabel.backgroundColor = .clear
                    subcategoryCollectionViewCell.subcategoryTitleLabel.textColor       = .darkGray
                }
                
                // Notify the delegate for selection
                if let delegate = delegate {
                    delegate.didSelect(subcategory: self, item: subcategory, selected: subcategory.isSelected)
                }
            }
        }
    }
    
    // MARK: - Reload Data
    
    func reloadSubcategory(with subcategories: Array<Category>?) {
        datasource = subcategories
        subcategoryCollectionView.reloadData()
    }
    
    func refreshLayout(isFull display: Bool) {
        isFullDisplay = display
        subcategoryCollectionView.reloadData()
        let indexPath = IndexPath.init(item: lastSelectedRow, section: 0)
        subcategoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension Subcategory: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Datasource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure Subcategories
        let subcategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.subcategoryCell, for: indexPath) as! SubcategoryCollectionViewCell
        if let subcategory = datasource?[indexPath.row] {
            if let imageURL = subcategory.imageURL {
                subcategoryCollectionViewCell.subcategoryImageView.setImage(withURL: imageURL, placeholder: nil)
            }
            subcategoryCollectionViewCell.subcategoryTitleLabel.text = subcategory.name.capitalized
            
            if subcategory.isSelected {
                subcategoryCollectionViewCell.subcategoryTitleLabel.backgroundColor = UIColor.darkTheme()
                subcategoryCollectionViewCell.subcategoryTitleLabel.textColor       = .white
            }
            else {
                subcategoryCollectionViewCell.subcategoryTitleLabel.backgroundColor = .clear
                subcategoryCollectionViewCell.subcategoryTitleLabel.textColor       = .darkGray
            }
        }
        return subcategoryCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell
        setSelection(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isFullDisplay {
            let totalCellWidth = cellSize.width * CGFloat(collectionView.numberOfItems(inSection: 0)/2)
            let totalSpacingWidth = CGFloat(8 * (collectionView.numberOfItems(inSection: 0) - 1)/2)
            
            var leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            if leftInset < 0 {
                leftInset = 0
            }
            let rightInset = leftInset
            
            
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        
        return UIEdgeInsets.zero
    }
}

// MARK: - Sub Category Delegate

protocol SubcategoryDelegate:class {
    // When subcategory is selected
    func didSelect(subcategory: Subcategory, item: Category, selected: Bool)
}
