//
//  OTPTextField.swift
//  Solviant
//
//  Created by Rohit Kumar on 25/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class OTPTextField: UITextField {
    
    weak var backwardKeyDelegate:UITextFieldBackwardDelegate?
    
    override public func deleteBackward() {
        if text!.isEmpty {
            // do something when backspace is tapped/entered in an empty text field
        }
        // do something for every backspace
        super.deleteBackward()
        backwardKeyDelegate?.didPressBackward(self)
    }
    
}

protocol UITextFieldBackwardDelegate:class {
    func didPressBackward(_ textField: OTPTextField)
}
