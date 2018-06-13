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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == String(describing: PrincipalModifiesPopupViewController.self)){
            if let modifyPopUp = segue.destination as? PrincipalModifiesPopupViewController {
                modifyPopUp.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }
        }
    }
    
    //MARK: - actions
    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func modifyStatement(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: PrincipalModifiesPopupViewController.self), sender: self)

    }
   
    @IBAction func confirmStatement(_ sender: Any) {
    }
    

     //MARK: - utility
    
    func customizeUI(){
        detailView.darkShadow(withRadius: 5.0)
    }
    
}
