//
//  RatingOverviewTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 18/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RatingOverviewTableViewCell: UITableViewCell {
    
    // MARK: IB Outlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet var ratingButtons: [UIButton]!
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!

    // MARK: Tag Config
    
    var textConfig:TTGTextTagConfig {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor                 = .white
        textConfig.tagBackgroundColor           = UIColor.lightTheme()
        textConfig.tagSelectedTextColor         = .white
        textConfig.tagSelectedBackgroundColor   = UIColor.lightTheme()
        return textConfig
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagCollectionView.scrollDirection = .horizontal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Configure Cell Data
    
    func set(tags categories:[Category], for expertLevel: ExpertLevel) {
        for button in ratingButtons {
            button.isSelected = button.tag <= expertLevel.rawValue
        }
        let (name, _)   = expertLevel.description()
        titleLabel.text = name
        for category in categories {
            tagCollectionView.addTag(category.name.capitalized, with: textConfig)
        }
    }

}
