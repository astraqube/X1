//
//  SelectRoleViewController.swift
//  X1
//
//  Created by Rohit Kumar on 30/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class SelectRoleViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var findSolutionButton: UIButton!
    @IBOutlet weak var giveSolutionButton: UIButton!
    @IBOutlet weak var whyHereLabel: UILabel!
    @IBOutlet weak var checkMarkFindSolutionImageView: UIImageView!
    @IBOutlet weak var checkMarkGiveSolutionImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Other Property
    
    var user:User?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectRole(_ sender: UIButton) {
        if sender == findSolutionButton {
            sender.isSelected                       = !sender.isSelected
            checkMarkFindSolutionImageView.isHidden = !sender.isSelected
        }
        else {
            sender.isSelected                       = !sender.isSelected
            checkMarkGiveSolutionImageView.isHidden = !sender.isSelected
        }
        nextButton.isHidden = !(findSolutionButton.isSelected || giveSolutionButton.isSelected)
    }
    
    @IBAction func nextScreen(_ sender: Any) {
        // Move to next screen after user role selection
        
        // Check for selected user role
        var userType:UserType!
        if checkMarkFindSolutionImageView.isHidden {
            // Resource is selected
            userType = .resource
        }
        else if checkMarkGiveSolutionImageView.isHidden {
            // Principal is selected
            userType = .principal
        }
        else {
            // Both are enabled
            userType = .both
        }
        
        // Decide which screen to appear after that
        if let user = self.user {
            // Coming for Linked Login (Go to Complete Profile screen)
            let profileViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.profile) as! ProfileViewController
            user.type                  = userType
            profileViewController.user = user
            navigationController?.pushViewController(profileViewController, animated: true)
        }
        else {
            // Standrad Sign Up process
            let signUpViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.signUp) as! SignUpViewController
            signUpViewController.userType = userType
            navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        // Customize UI for user appearance
        findSolutionButton.backgroundColor = .white
        findSolutionButton.darkShadow(withRadius: 10)
        findSolutionButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        findSolutionButton.layer.sublayers?.last?.cornerRadius = 7.0
        findSolutionButton.layer.sublayers?.last?.masksToBounds = true
        giveSolutionButton.darkShadow(withRadius: 10)
        giveSolutionButton.layer.borderWidth = 1.0
        giveSolutionButton.layer.borderColor = UIColor.lightTheme().cgColor
        nextButton.darkShadow(withRadius: 10)
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = UIColor.lightTheme().cgColor
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
}
