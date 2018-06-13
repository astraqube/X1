//
//  ResourcePricipalConfirmationViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 13/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ResourcePricipalConfirmationViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var detailView: UIView!
    
    //MARK: - property
    
    //MARK: - view life cycle
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == String(describing: ConfirmedPopupViewController.self)){
            if let confirmPopup = segue.destination as? ConfirmedPopupViewController {
                confirmPopup.view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            }
        }
    }
    
    
    //MARK: - actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func reschedule(_ sender: Any) {
    }
    @IBAction func confirm(_ sender: Any) {
        
        self.performSegue(withIdentifier: String(describing: ConfirmedPopupViewController.self), sender: self)
        
    }
    
    
    //MARK: - utility
    
    func customizeUI(){
        detailView.darkShadow(withRadius: 5.0)
    }

}
