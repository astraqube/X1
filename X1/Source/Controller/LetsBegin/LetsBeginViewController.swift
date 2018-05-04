//
//  LetsBeginViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 04/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class LetsBeginViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var startExploringButton: UIButton!
    
    // MARK: - Other Property
    
    var user:User!
    
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
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Set border for Button
        startExploringButton.backgroundColor = .white
        startExploringButton.darkShadow(withRadius: 10)
        startExploringButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        startExploringButton.layer.sublayers?.last?.cornerRadius = 7.0
        startExploringButton.layer.sublayers?.last?.masksToBounds = true
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let homeViewController = segue.destination as? HomeViewController {
            homeViewController.user = user
        }
    }

}
