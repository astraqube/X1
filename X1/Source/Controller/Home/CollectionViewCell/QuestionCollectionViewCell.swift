//
//  QuestionCollectionViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 11/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import SwiftDate

class QuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet var statmentRatingImageViews: [UIImageView]!
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var statementTableView: UITableView!
    
    var redefinedStatements:[ProblemEvolution.RedefinedStatement]?
    
    var textTagConfig:TTGTextTagConfig  {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor = UIColor.white
        textConfig.tagBackgroundColor = UIColor.lightTheme()
        textConfig.tagBorderColor     = .clear
        return textConfig
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.darkShadow(withRadius: 5)
        if tagCollectionView != nil {
            tagCollectionView.alignment       = .left
            tagCollectionView.scrollDirection = .horizontal
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if tagCollectionView != nil {
            tagCollectionView.removeAllTags()
        }
    }
    
    func configureCell(with statement: Statement) {
        // Common fields
        timeDurationLabel.text  = (statement.time?.colloquial(to: Date()))?.capitalized
        statementLabel.text     = statement.problemText
        if let tags = statement.tags {
            tagCollectionView.addTags(tags, with: textTagConfig)
        }
        
        guard usernameLabel != nil  else {
            return
        }
        if let imageURL = statement.userImageURL {
            userImageView.setImage(withURL: imageURL, placeholder: #imageLiteral(resourceName: "user-icon"))
        }
        usernameLabel.text      = statement.name?.capitalized
        cityLabel.text          = statement.city?.capitalized
        
        // Set user rating for this post
        let count = statmentRatingImageViews.count
        for index in 0..<count {
            let imageView = statmentRatingImageViews[index]
            imageView.image = index <= statement.expertLevel.rawValue ? #imageLiteral(resourceName: "starPuActiveIcon") : #imageLiteral(resourceName: "star_faded")
        }
    }
    
    func configureRedefinedCell(with statement: ProblemEvolution) {
        usernameLabel.text       = statement.name
        cityLabel.text           = statement.city?.capitalized
        redefinedStatements      = statement.redefinedStatements
        statementTableView.reloadData()
    }
}


extension QuestionCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return redefinedStatements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.problemEvolutionCell, for: indexPath) as! RedefinedStatementTableViewCell
        if indexPath.row == 0 {
            // First row is configured for Original Problem Statment
            tableViewCell.redefinedLabel.isHidden = true
            tableViewCell.viewLeadingSpaceConstraint.constant = 0
        }
        else {
            // Following rows are configured for Redefined Problem Statments
            tableViewCell.viewLeadingSpaceConstraint.constant = 10
            tableViewCell.redefinedLabel.isHidden = false
        }
        tableViewCell.containerView.updateConstraints()
        if let redefinedStatement = redefinedStatements?[indexPath.row] {
            tableViewCell.problemStatementLabel.text = redefinedStatement.statement
            tableViewCell.timeLabel.text             = redefinedStatement.dateTime?.colloquial(to: Date())?.capitalized
            if let allTags = redefinedStatement.categories {
                let hashtags = allTags.map{$0};
                tableViewCell.tagCollectionView.addTags(hashtags, with: textTagConfig)
            }
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
