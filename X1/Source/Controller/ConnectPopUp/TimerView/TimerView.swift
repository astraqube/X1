//
//  TimerView.swift
//  Solviant
//
//  Created by Sushil Mishra on 11/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class TimerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let timerView = Bundle.main.loadNibNamed("TimerView", owner: self, options: [:])?.first as? UIView {
            timerView.frame = self.bounds
            self.addSubview(timerView)
        }
    }

}
