//
//  PrincipalStatementDetailViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 12/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Popover

class PrincipalStatementDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var detailView: UIView!
    @IBOutlet var availabilityView: AvailabilityView!
    
    //MARK: - Property
    
    var selectAvailabilityStr = NSLocalizedString("30_minutes", comment: "")
    var popover:Popover?
    
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
        
        self.performSegue(withIdentifier: String(describing: ResourcePricipalConfirmationViewController.self), sender: self)

        
    }
    
    @IBAction func addAvailability(_ sender: Any) {
        
        popover?.dismiss()
        popover = nil
        let options = [
            .type(.up),
            .cornerRadius(5),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.lightGray.withAlphaComponent(0.3)),
            .arrowSize(CGSize.init(width: 10, height: 10))
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        availabilityView.frame = CGRect.init(x: 0, y: 0, width: 170, height: 128)
        popover?.show(availabilityView, fromView: sender as! UIView)
        
    }
    
     //MARK: - utility
    
    func customizeUI(){
        detailView.darkShadow(withRadius: 5.0)
        availabilityView.configure()
        availabilityView.selectAvailability = {(result, error) in
            if error == nil{
                self.popover?.dismiss()
                self.selectAvailabilityStr = (result?.title)!
            }
        }
        
    }
    
}
