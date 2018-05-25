//
//  LandingViewController.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    // MARK: - IB Outlet
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var beginLabel: UILabel!
    
    
    // MARK: - Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        perform(#selector(presentOTPBox), with: self, afterDelay: 3)
    }
    
    @objc func presentOTPBox() {
        let otpBox = OTPBox.init(frame: self.view.frame)
        otpBox.present(on: self.view)
    } */
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        // Customize UI for user appearance
        logInButton.backgroundColor = .white
        logInButton.darkShadow(withRadius: 10)
        logInButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        logInButton.layer.sublayers?.last?.cornerRadius = 7.0
        logInButton.layer.sublayers?.last?.masksToBounds = true
        signUpButton.darkShadow(withRadius: 10)
        signUpButton.layer.borderWidth = 1.0
        signUpButton.layer.borderColor = UIColor.lightTheme().cgColor
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.

    }

}
