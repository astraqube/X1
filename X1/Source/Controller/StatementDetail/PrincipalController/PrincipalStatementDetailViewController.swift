//
//  PrincipalStatementDetailViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 12/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PrincipalStatementDetailViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var detailView: UIView!
    
    //MARK: - view life cycle
    override func loadView() {
        super.loadView()
        self.customizeUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

     //MARK: - utility
    
    func customizeUI(){
        detailView.darkShadow(withRadius: 5.0)
    }
    
}
