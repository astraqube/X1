//
//  RedefinedStatementTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 15/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RedefinedStatementTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var problemStatementLabel: UILabel!
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var redefinedLabel: UILabel!
    @IBOutlet weak var viewLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if tagCollectionView != nil {
            tagCollectionView.enableTagSelection = false
            tagCollectionView.scrollDirection    = .horizontal
            tagCollectionView.alignment          = .fillByExpandingWidth
            tagCollectionView.scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if tagCollectionView != nil {
            tagCollectionView.removeAllTags()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
