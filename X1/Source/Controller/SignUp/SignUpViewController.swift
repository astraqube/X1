//
//  SignUpViewController.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Whisper

class SignUpViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Other Properties
    
    let webManager      = WebRequestManager()
    var user            = User()
    let linkedInManager = LinkedIn()
    var userType:UserType!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add notification to observe Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Customize UI for theme appearance
        customizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // Remove Keyboard observer before it gets deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Set border for Button
        signUpButton.backgroundColor = .white
        signUpButton.darkShadow(withRadius: 10)
        signUpButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        signUpButton.layer.sublayers?.last?.cornerRadius = 7.0
        signUpButton.layer.sublayers?.last?.masksToBounds = true
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signInWithLinkedIn(_ sender: Any) {
        linkedInManager.loginWithLinkedIn { (linkedInUser) in
            // Autheticated
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let status = isValid()
        if status {
            view.endEditing(true)
            
            // Assign properties
            user.email    = emailTextField.text?.trimmingCharacters(in: .whitespaces)
            user.name     = nameTextField.text?.trimmingCharacters(in: .whitespaces)
            user.password = passwordTextField.text
            user.type     = userType
            
            let profileViewController  = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.profile) as! ProfileViewController
            profileViewController.user = user
            navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility
    
    private func showAlert(withMessage message: String) {
        // Show alert to user
        let announcement = Announcement(title: "Sign In", subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
            
        })
    }
    
    private func clearTextFields() {
        emailTextField.text    = nil
        passwordTextField.text = nil
        nameTextField.text     = nil
    }
    
    // MARK: - Validation
    
    func isValid() -> Bool {
        // Validate all text fields
        var status = true
        
        // 1. Name
        
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) {
            if name.isEmpty {
                let message = NSLocalizedString("nameMissing", comment: "")
                nameTextField.errorMessage = message
            }
        }
        
        // 2. Email
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) {
            if email.isEmpty {
                let message = NSLocalizedString("emailMissing", comment: "")
                emailTextField.errorMessage = message
                status = false
            }
            if !email.isValidEmail() {
                let message = NSLocalizedString("invalidEmail", comment: "")
                emailTextField.errorMessage = message
                status = false
            }
        }
        
        
        // 3. Password
        if passwordTextField.text!.isEmpty {
            let message = NSLocalizedString("passwordMissing", comment: "")
            passwordTextField.errorMessage = message
            status  = false
        }
        else if !passwordTextField.text!.isValidPassword() {
            let message = NSLocalizedString("invalidPassword", comment: "")
            passwordTextField.errorMessage = message
            status  = false
        }
        else if passwordTextField.text!.isOverFlowing() {
            let message = NSLocalizedString("overflowingChars", comment: "")
            passwordTextField.errorMessage = message
            status  = false
        }
        
        return status
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    // MARK: - Keyboard Notification
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let scrollViewFrame = scrollView.frame
            let scrollViewY     = view.frame.size.height -  (scrollViewFrame.origin.y + scrollViewFrame.size.height)
            scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height-scrollViewY + 10, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as! SkyFloatingLabelTextField).errorMessage = nil
        return true
    }
}

