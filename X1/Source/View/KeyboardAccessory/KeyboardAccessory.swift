//
//  KeyboardAccessory.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

class KeyboardAccessory: UIView {
    
    // MARK: - Delegate
    
    weak var delegate:KeyboardAccessoryDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view    = Bundle.main.loadNibNamed("KeyboardAccessory", owner: self, options: [:])?.first as! UIView
        view.frame  = self.bounds
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Button Action
    
    @IBAction func keyboardAccessoryButtonTapped(_ sender: UIButton) {
        if let keyboaradAcessoryDelegate = delegate {
            let actionType = KeyboardAccessoryButton(rawValue:sender.tag)
            keyboaradAcessoryDelegate.keyboardAction(type: actionType!)
        }
    }
}

// MARK: - Protocol Definition

protocol KeyboardAccessoryDelegate:class {
    // When user presses keyboard accessory buttons
    func keyboardAction(type: KeyboardAccessoryButton);
}

// MARK: - Button Types

enum KeyboardAccessoryButton:Int {
    // Buttton Types
    case leftButton
    case rightButton
    case hideKeyboard
}
