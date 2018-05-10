//
//  InterestTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 07/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class InterestTableViewCell: UITableViewCell {

    // MARK:- IB Outlet
    
    @IBOutlet weak var interestCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Other Property
    
    weak var delegate:TagSelectionDelegate?
    
    var datasource:[String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state
        configureTagView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Utility
    
    private func configureTagView() {
        interestCollectionView.alignment       = .fillByExpandingWidth
        interestCollectionView.delegate        = self
        interestCollectionView.scrollDirection = .horizontal
        interestCollectionView.horizontalSpacing = 8
    }

    
    // MARK:- Set Datasource
    
    func setInterest(for interests: [Category]) {
        interestCollectionView.removeAllTags()
        let count = interests.count
        for index in 0..<count {
            let tag = interests[index]
            interestCollectionView.addTag(tag.name.capitalized)
            if tag.isSelected {
                interestCollectionView.setTagAt(UInt(index), selected: true)
            }
        }
    }
    
    func removeInterest() {
        interestCollectionView.removeAllTags()
    }
}

protocol TagSelectionDelegate:class {
    // To forward tag selection to parent classes
    func didTap(_ tableCell: UITableViewCell, at Tagindex: Int, selected: Bool)
}

extension InterestTableViewCell: TTGTextTagCollectionViewDelegate {
    
    // MARK: - TagCollectionView Delegate
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        // Tag Selected
        if let delegate = delegate {
            delegate.didTap(self, at: Int(index), selected: selected)
        }
    }
}

