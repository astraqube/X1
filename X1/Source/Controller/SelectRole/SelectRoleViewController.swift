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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let signUpViewController = segue.destination as? SignUpViewController {
            if checkMarkFindSolutionImageView.isHidden {
                // Resource is selected
                signUpViewController.userType = .resource
            }
            else if checkMarkGiveSolutionImageView.isHidden {
                // Principal is selected
                signUpViewController.userType = .principal
            }
            else {
                // Both are enabled
                signUpViewController.userType = .both
            }
        }
    }
}
