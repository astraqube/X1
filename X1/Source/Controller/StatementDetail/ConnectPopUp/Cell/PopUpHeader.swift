//
//  PopUpHeader.swift
//  Solviant
//
//  Created by Sushil Mishra on 07/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PopUpHeader: UIView {

    @IBOutlet weak var titleView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("PopUpHeader", owner: self, options: [:])?.first as? UIView {
            subView.frame = self.bounds
            addSubview(subView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
