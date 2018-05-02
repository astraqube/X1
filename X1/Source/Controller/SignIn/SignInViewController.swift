//
//  SignInViewController.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Whisper

class SignInViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Other Property
    
    let webManager           = WebRequestManager()
    let linkedInManager      = LinkedIn()
    let user                 = User()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize UI for theme apperance
        customizeUI()
        
        // Add notification to observe Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        // Remove Keyboard observer before it gets deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        guard !activityIndicator.isAnimating else {
            return
        }
        let status = isValid()
        if status {
            // Forward implementation is in progress
            view.endEditing(true)
            user.email      = emailTextField.text?.trimmingCharacters(in: .whitespaces)
            user.password   = passwordTextField.text
            let parameters  = user.loginParameters()
            requestSignIn(withParameters: parameters)
        }
    }
    
    
    @IBAction func signInWithLinkedIn(_ sender: Any) {
        guard  !activityIndicator.isAnimating else {
            return
        }
        linkedInManager.loginWithLinkedIn { (linkedInUser) in
            // Autheticated
        }
    }
    
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Set border for Button
        signInButton.backgroundColor = .white
        signInButton.darkShadow(withRadius: 10)
        signInButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        signInButton.layer.sublayers?.last?.cornerRadius = 7.0
        signInButton.layer.sublayers?.last?.masksToBounds = true
    }
    
    private func showAlert(withMessage message: String) {
        // Show alert to user
        let announcement = Announcement(title: NSLocalizedString("unableToProceed", comment: ""), subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
    
        })
    }
    
    private func clearTextFields() {
        emailTextField.text    = nil
        passwordTextField.text = nil
    }
    
    // MARK: - Validation
    
    func isValid() -> Bool {
        // Validate all text fields
        var status = true
        // 1. Email
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
        
        // 2. Password
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
        return !activityIndicator.isAnimating
    }
    
    private func gotoHomeScreen(forUser user: User) {
        // Move to next screen after Sign Up
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.home) as? HomeViewController {
            homeViewController.user = user
            navigationController?.pushViewController(homeViewController, animated: true)
        }
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

extension SignInViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !activityIndicator.isAnimating
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as! SkyFloatingLabelTextField).errorMessage = nil
        return true
    }
}

extension SignInViewController {
    // MARK: - Network Request
    
    private func requestSignIn(withParameters parameters: Dictionary<String, Any>) {
        // Create user account using filled details
        activityIndicator.startAnimating()
        weak var weakSelf = self
        activityIndicator.startAnimating()
        let url = APIURL.url(apiEndPoint: APIEndPoint.signIn)
        webManager.httpRequest(method: .post, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.didSignIn(withResponse: response)
        }) { (error) in
            // Request failed
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.showAlert(withMessage: NSLocalizedString("unexpectedErrorMessage", comment: ""))
        }
    }
    
    // MARK: - Request Completion
    
    private func didSignIn(withResponse response: Dictionary<String, Any>) {
        activityIndicator.stopAnimating()
        if let statusCode = response[APIKeys.status] as? String {
            if statusCode == HTTPStatus.success {
                guard let result = response[APIKeys.result] as? Dictionary<String, Any>,
                    let userInfo = result[APIKeys.userInfo] as? Dictionary<String, Any>,
                    let accessToken = result[UserKey.accessToken] as? String else {
                        return
                }
                // Go to next screen
                if let loggedInUser = User.init(response: userInfo) {
                    loggedInUser.accessToken = accessToken
                    loggedInUser.save()
                    gotoHomeScreen(forUser: loggedInUser)
                }
            }
        }
        else if let errorMessage = response[APIKeys.errorMessage] as? String {
            // Show  error
            showAlert(withMessage: errorMessage)
        }
    }
}


