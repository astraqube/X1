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
    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed(String(describing: PopUpHeader.self), owner: self, options: [:])?.first as? UIView {
            subView.frame = self.bounds
            addSubview(subView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateTitle(titleStr: String){
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if self.titleLabel != nil{
                self.titleLabel.text = titleStr
            }
        }
        
       
    }

}
