//
//  HomeViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 02/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet var buttonContainerViews: [UIView]!
    @IBOutlet weak var problemContainerView: UIView!
    
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
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        // Customize for theme appearance
       
        badgeCountLabel.layer.cornerRadius  = 9
        badgeCountLabel.layer.masksToBounds = true
        gradientView.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        problemContainerView.darkShadow(withRadius: 4)
        for view in buttonContainerViews {
            view.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        }
    }
    
    // MARK: - IB Action
    
    @IBAction func openMenu(_ sender: Any) {
        // Log out user temporarily
        user.delete()
        let landingViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.landing)
        navigationController?.setViewControllers([landingViewController!], animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
}
