//
//  StatementCardView.swift
//  Solviant
//
//  Created by Rohit Kumar on 28/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import SwiftDate

class StatementCardView: UIView {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var statementTextLabel: UILabel!
    @IBOutlet weak var tagCollectionView: TTGTextTagCollectionView!
    
    // MARK: - TagConfig
    
    var textTagConfig:TTGTextTagConfig  {
        let textConfig = TTGTextTagConfig()
        textConfig.tagTextColor = UIColor.lightTheme()
        textConfig.tagBackgroundColor = UIColor.white
        return textConfig
    }
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("StatementCardView", owner: self, options: [:])?.first as? UIView {
            subView.frame = self.bounds
            addSubview(subView)
        }
        
        self.backgroundColor = .clear
        self.darkShadow(withRadius: 10)
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.sublayers?.last?.cornerRadius = 8.0
        self.layer.sublayers?.last?.masksToBounds = true
        tagCollectionView.scrollDirection = .horizontal
        tagCollectionView.enableTagSelection   = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Data Configuration

    func setCard(for statement: Statement) {
        // Set data for card
        usernameLabel.text          = statement.name?.capitalized
        locationLabel.text          = statement.city?.capitalized
        dateTimeLabel.text          = (statement.time?.colloquial(to: Date()))?.capitalized
        statementTextLabel.text     = statement.problemText
        if let tags = statement.tags {
            tagCollectionView.addTags(tags, with: textTagConfig)
        }
    }
    
}
