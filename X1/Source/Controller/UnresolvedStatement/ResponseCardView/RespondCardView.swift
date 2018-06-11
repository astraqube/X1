//
//  RespondCardView.swift
//  Solviant
//
//  Created by Rohit Kumar on 08/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RespondCardView: UIView {

    // MARK: - IB Outlet
    
    @IBOutlet var ratingStartButtons: [UIImageView]!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("RespondCardView", owner: self, options: [:])?.first as? UIView {
            subView.frame = self.bounds
            addSubview(subView)
        }
        
        self.backgroundColor = .clear
        self.darkShadow(withRadius: 10)
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.sublayers?.last?.cornerRadius = 8.0
        self.layer.sublayers?.last?.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Data Configuration
    
    func setCard(for response: Response) {
        // Set data for card
        usernameLabel.text     = response.resourceName.capitalized
        locationLabel.text     = response.city?.capitalized
        timeLabel.text         = (response.time?.colloquial(to: Date()))?.capitalized
        responseLabel.text     = response.question
    }
}
