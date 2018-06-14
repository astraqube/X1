//
//  DefineStatementAlertController.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class DefineStatementAlertController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var detailView: UIView!
    
    //MARK: - View Life Cycle
    
    override func loadView() {
        super.loadView()
        customizeUI()
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
    
    //MARK: - Actions
    
    @IBAction func proceed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Utility
    
    func customizeUI(){
        self.detailView.darkShadow(withRadius: 5)
    }

}
