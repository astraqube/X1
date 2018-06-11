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
    @IBOutlet weak var linkedInActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Other Property
    
    let webManager           = WebRequestManager()
    let linkedInManager      = LinkedIn()
    var linkedInUser:LinkedInUser!
    let user                 = User()
    var isProcessing         = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: Any) {
        guard !isProcessing else {
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        guard !isProcessing else {
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
        guard  !isProcessing else {
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
        // Move to next screen after Sign In
        if let homeTabBarController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.tabBar) as? HomeTabBarViewController {
            homeTabBarController.selectedIndex = TabBarIndex.home.rawValue
            homeTabBarController.user = user
            navigationController?.pushViewController(homeTabBarController, animated: true)
        }
    }
    
    private func gotoUserRoleScreen(forUser user: User) {
        // Move to next screen for linked in new user
        if let selectRoleViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.selectRole) as? SelectRoleViewController {
            selectRoleViewController.user = user
            navigationController?.pushViewController(selectRoleViewController, animated: true)
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
        return !isProcessing
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
        let url = APIURL.url(apiEndPoint: APIEndPoint.signIn)
        isProcessing = true
        webManager.httpRequest(method: .post, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.didSignIn(withResponse: response)
            weakSelf?.isProcessing = false
        }) { (error) in
            // Request failed
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.isProcessing = false
            weakSelf?.showAlert(withMessage: NSLocalizedString("unexpectedErrorMessage", comment: ""))
        }
    }
    
    private func requestLinkedInLogin(withParameters parameters: Dictionary<String, Any>) {
        linkedInActivityIndicator.startAnimating()
        weak var weakSelf = self
        let url = APIURL.url(apiEndPoint: APIEndPoint.linkedInLogin)
        isProcessing = true
        webManager.httpRequest(method: .post, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.linkedInActivityIndicator.stopAnimating()
            weakSelf?.didLinkedSignIn(withResponse: response)
            weakSelf?.isProcessing = false
        }) { (error) in
            // Request failed
            weakSelf?.linkedInActivityIndicator.stopAnimating()
            weakSelf?.isProcessing = false
            weakSelf?.showAlert(withMessage: NSLocalizedString("unexpectedErrorMessage", comment: ""))
        }
    }
    
    // MARK: - Request Completion
    
    private func didSignIn(withResponse response: Dictionary<String, Any>) {
        // User sign in response received
        if let statusCode = response[APIKeys.status] as? String {
            // Logged in successfully
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
                                gotoUserRoleScreen(forUser: user)
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


