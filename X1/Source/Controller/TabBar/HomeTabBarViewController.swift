//
//  HomeTabBarViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 11/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    var user:User!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }

}
