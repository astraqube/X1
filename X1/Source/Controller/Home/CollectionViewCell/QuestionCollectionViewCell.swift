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
    
    var redefinedStatements:[ProblemEvolution]?
    
    var textTagConfig:TTGTextTagConfig  {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor = UIColor.lightTheme()
        textConfig.tagBackgroundColor = UIColor.white
        return textConfig
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.darkShadow(withRadius: 5)
        tagCollectionView.enableTagSelection = false
        tagCollectionView.scrollDirection    = .horizontal
        tagCollectionView.alignment          = .fillByExpandingWidth
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagCollectionView.removeAllTags()
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
        // Common fields
        /*  timeDurationLabel.text  = (statement.time?.colloquial(to: Date()))?.capitalized
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
         } */
        statementLabel.text = statement.statement
        timeDurationLabel.text   = statement.dateTime
        if let tags = statement.categories {
            tagCollectionView.addTags(tags, with: textTagConfig)
        }
        cityLabel.text           = statement.location
        redefinedStatements      = statement.redefinedStatements
    }
}


extension QuestionCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return redefinedStatements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.problemEvolutionCell, for: indexPath) as! RedefinedStatementTableViewCell
        if let problemEvolution = redefinedStatements?[indexPath.row] {
            tableViewCell.problemStatementLabel.text = problemEvolution.statement
            tableViewCell.timeLabel.text             = problemEvolution.dateTime
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
