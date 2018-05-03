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
    @IBOutlet weak var linkedInActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Other Properties
    
    let webManager      = WebRequestManager()
    var user            = User()
    let linkedInManager = LinkedIn()
    var linkedInUser:LinkedInUser!
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
        guard !linkedInActivityIndicator.isAnimating else {
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signInWithLinkedIn(_ sender: Any) {
        guard !linkedInActivityIndicator.isAnimating else {
            return
        }
        weak var weakSelf = self
        linkedInManager.loginWithLinkedIn { (linkedInUser) in
            // Autheticated
            weakSelf?.linkedInUser = linkedInUser
            let parameters = linkedInUser.parameteres()
            weakSelf?.requestLinkedInLogin(withParameters: parameters)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard !linkedInActivityIndicator.isAnimating else {
            return
        }
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
    
    private func gotoCompletProfileScreen(forUser user: User) {
        // Move to next screen for linked in new user
        if let profileViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.profile) as? ProfileViewController {
            user.type                  = userType
            profileViewController.user = user
            navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    private func gotoHomeScreen(forUser user: User) {
        // Move to next screen after Sign In
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !linkedInActivityIndicator.isAnimating
    }
}

extension SignUpViewController {
    
    // MARK: - Netowork Request
    
    private func requestLinkedInLogin(withParameters parameters: Dictionary<String, Any>) {
        linkedInActivityIndicator.startAnimating()
        weak var weakSelf = self
        let url = APIURL.url(apiEndPoint: APIEndPoint.linkedInLogin)
        webManager.httpRequest(method: .post, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.linkedInActivityIndicator.stopAnimating()
            weakSelf?.didLinkedSignIn(withResponse: response)
        }) { (error) in
            // Request failed
            weakSelf?.linkedInActivityIndicator.stopAnimating()
            weakSelf?.showAlert(withMessage: NSLocalizedString("unexpectedErrorMessage", comment: ""))
        }
    }
    
    // MARK: - Request Completion
    
    private func didLinkedSignIn(withResponse response: Dictionary<String, Any>) {
        // User sign in response received
        if let statusCode = response[APIKeys.status] as? String {
            // Logged in successfully
            if statusCode == HTTPStatus.success {
                guard let result = response[APIKeys.result] as? Dictionary<String, Any>,
                    let userInfo = result[APIKeys.userInfo] as? Dictionary<String, Any>,
                    let accessToken = result[UserKey.accessToken] as? String else {
                        // Check if this is for the new user
                        if let httpCode = response[APIKeys.statusCode] as? Int, httpCode == HTTPStatus.ok {
                            // This is the new user. Go to Select Role screen with this user
                            if let user = User.init(withLinkedIn: linkedInUser) {
                                gotoCompletProfileScreen(forUser: user)
                            }
                        }
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

