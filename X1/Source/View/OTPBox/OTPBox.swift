//
//  OTPBox.swift
//  Solviant
//
//  Created by Rohit Kumar on 25/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class OTPBox: UIView {

    // MARK: - IB Outlet
    
    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet var otpTextFieldCollection: [OTPTextField]!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resentButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate:OTPBoxDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("OTPBox", owner: self, options: [:])?.first as? UIView {
            subView.frame = self.bounds
            self.addSubview(subView)
            subView.darkShadow(withRadius: 5)
            
            // Set the delegate for OTP backward delete
            for textfield in otpTextFieldCollection {
                textfield.backwardKeyDelegate = self
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: OTPTextField) {
        if !sender.text!.isEmpty, let index = otpTextFieldCollection.index(of: sender ) {
            nextResponder(with: index)
        }
        for textfield in otpTextFieldCollection {
            if let text = textfield.text?.trimmingCharacters(in: .whitespaces) {
                if text.isEmpty {
                    verifyButton.isEnabled = false
                    verifyButton.alpha    = 0.5
                    break
                }
                else {
                    verifyButton.isEnabled = true
                    verifyButton.alpha    = 1.0
                }
            }
        }
    }
    
    
    // MARK: - Button Action
    
    @IBAction func cancelVerification(_ sender: Any) {
        close()
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        var otpString = String()
        for textfield in otpTextFieldCollection {
            if let text = textfield.text?.trimmingCharacters(in: .whitespaces) {
                otpString += text
            }
        }
        if otpString.count == otpTextFieldCollection.count {
            // Go for the verificataion
            activityIndicator.startAnimating()
            perform(#selector(textfieldValidated), with: self, afterDelay: 3)
        }
    }
    
    @IBAction func resentCode(_ sender: Any) {
    }
    
    @objc func textfieldValidated() {
        close()
    }
    
    // MARK: - Animation work
    
    func present(on view: UIView) {
        // Present with bounce animation
        self.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        view.addSubview(self)
        self.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }) { (status) in
            
        }
    }
    
    func close() {
        // Close with bounce animation
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.1
        }) { (status) in
            if status {
                self.isHidden = true
                self.removeFromSuperview()
                self.delegate?.didDismiss(otpbox: self)
            }
        }
    }
}


extension OTPBox: UITextFieldDelegate, UITextFieldBackwardDelegate {
    
    func nextResponder(with index: Int) {
        if otpTextFieldCollection.count > index+1 {
            let nextTextField = otpTextFieldCollection[index+1]
            nextTextField.becomeFirstResponder()
        }
        else {
            self.endEditing(true)
        }
    }
    
    func prevResponder(with index: Int) {
        if index > 0 {
            let prevTextField = otpTextFieldCollection[index-1]
            prevTextField.becomeFirstResponder()
        }
        else {
            self.endEditing(true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        print("Outside cell --> New text \(string)")
        
        if textField.text!.isEmpty {
            return true
        }
        else {
            if let index = otpTextFieldCollection.index(of: textField as! OTPTextField) {
                let nextIndex = index + 1
                if otpTextFieldCollection.count > nextIndex {
                    let nextTextField = otpTextFieldCollection[nextIndex]
                    nextTextField.text = string
                    nextTextField.becomeFirstResponder()
                }
                else {
                    textField.resignFirstResponder()
                }
            }
            return false
        }
    }
    
    
    
    func didPressBackward(_ textField: OTPTextField) {
        if let index = otpTextFieldCollection.index(of: textField) {
            prevResponder(with: index)
        }
    }
}

protocol OTPBoxDelegate:class {
    func didDismiss(otpbox: OTPBox)
}
