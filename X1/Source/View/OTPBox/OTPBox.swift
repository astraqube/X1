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
    
    // MARK: - Verification Delegate
    
    weak var delegate:OTPBoxDelegate?
    let webRequestManager = WebRequestManager()
    
    // MARK: - Other Property
    
    var user:User!
    var accessCode = String()
    
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
        enableVerifyButton()
    }
    
    
    // MARK: - Button Action
    
    private func enableVerifyButton() {
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
            guard !activityIndicator.isAnimating, let cellNumber = user.cellNumber, let countryCode = user.countryCode else {
                return
            }
            // Go for the verificataion
            activityIndicator.startAnimating()
            // Prepare parameters
            var parameters:[String:Any] = Dictionary()
            parameters[UserKey.phoneNumber]     = cellNumber
            parameters[UserKey.countryCode]     = String(countryCode.dropFirst())
            parameters[UserKey.userIdentifier]  = user.userId
            parameters[UserKey.otpCode]         = otpString
            
            requestVerifyOTP(with: parameters)
        }
        
    }
    
    @IBAction func resentCode(_ sender: UIButton) {
        guard !activityIndicator.isAnimating, let cellNumber = user.cellNumber, let countryCode = user.countryCode else {
            return
        }
        var parameters:[String:Any] = Dictionary()
        parameters[UserKey.mobile]          = cellNumber
        parameters[UserKey.countryCode]     = String(countryCode.dropFirst())
        requestResendOTP(with: parameters)
        sender.isEnabled = false;
        sender.alpha     = 0.5
        // Enable after 20 seconds
        perform(#selector(enableResendOTP), with: self, afterDelay: 20);
    }
    
    // MARK: - Animation work
    
    @objc func enableResendOTP() {
        resentButton.isEnabled = true;
        resentButton.alpha     = 1.0
    }
    
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
        enableVerifyButton()
        if (isBackSpace == -92) {
            return true
        }
        
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
            enableVerifyButton()
            return false
        }
    }
    
    func didPressBackward(_ textField: OTPTextField) {
        if let index = otpTextFieldCollection.index(of: textField) {
            prevResponder(with: index)
        }
    }
}

extension OTPBox {

    // Network Request
    
    fileprivate func requestVerifyOTP(with parameters: Dictionary<String, Any>) {
        // Validate Mobile OTP
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.verifyOTP)
        weak var weakself = self
        webRequestManager.httpRequest(method: .post, apiURL: apiURL, body: parameters, completion: { (response) in
            weakself?.activityIndicator.stopAnimating()
            if let result = response[APIKeys.result] as? Dictionary<String, Any>,
                let isMobileVerified = result[APIKeys.isMobileVerified] as? Bool,
                isMobileVerified == true {
                weakself?.close()
            }
            else {
                weakself?.otpContainerView.shake()
            }
            
        }) { (error) in
            weakself?.activityIndicator.stopAnimating()
            weakself?.otpContainerView.shake()
        }
    }
    
    fileprivate func requestResendOTP(with parameters: Dictionary<String, Any>) {
        // Validate Mobile OTP
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.resendOTP)
        weak var weakself = self
        webRequestManager.httpRequest(method: .post, apiURL: apiURL, body: parameters, completion: { (response) in
            weakself?.activityIndicator.stopAnimating()
        }) { (error) in
            weakself?.activityIndicator.stopAnimating()
        }
    }
}

protocol OTPBoxDelegate:class {
    func didDismiss(otpbox: OTPBox)
}
