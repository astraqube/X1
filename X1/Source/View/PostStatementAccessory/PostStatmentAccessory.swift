//
//  PostStatmentAccessory.swift
//  Solviant
//
//  Created by Rohit Kumar on 23/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PostStatmentAccessory: UIView {

    @IBOutlet weak var selectTagsButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var selectRatingButton: UIButton!
    @IBOutlet weak var selectDurationButton: UIButton!
    @IBOutlet weak var postStatementButton: UIButton!
    
    // MARK: Property
    
    weak var delegate:PostStatmentAccessoryDelegate?
    
    // MARK: Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view    = Bundle.main.loadNibNamed("PostStatmentAccessory", owner: self, options: [:])?.first as! UIView
        view.frame  = self.bounds
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Action
    
    @IBAction func postStatmentAccesoryAction(_ sender: UIButton) {
        if let postDelegate = delegate, let buttonType = AttachmentAccesoryType(rawValue: sender.tag) {
            postDelegate.didSelect(post: self, sender: sender, action: buttonType)
        }
    }
    
}


enum AttachmentAccesoryType: Int {
    case image
    case category
    case rating
    case priority
    case post
}

protocol PostStatmentAccessoryDelegate:class {
    
    // MARK: - Selection Delegate
    
    func didSelect(post accessory : PostStatmentAccessory, sender button:UIButton, action type: AttachmentAccesoryType)
    
}
