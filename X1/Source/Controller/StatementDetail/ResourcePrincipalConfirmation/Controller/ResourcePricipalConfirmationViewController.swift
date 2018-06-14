//
//  ResourcePricipalConfirmationViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 13/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Popover

class ResourcePricipalConfirmationViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var detailView: UIView!
    @IBOutlet var availablityView: AvailabilityView!
    
    //MARK: - Property
    
    var selectAvailabilityStr = NSLocalizedString("30_minutes", comment: "")
    var popover:Popover?
    var user:User! = User.loggedInUser()

    
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
        else if (segue.identifier == String(describing: PrincipalAvailablityViewController.self)){
            if let principalAvailability = segue.destination as? PrincipalAvailablityViewController {
                principalAvailability.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
    @IBAction func addAvailability(_ sender: Any) {
        if user.type == .principal {
            self.performSegue(withIdentifier: String(describing: PrincipalAvailablityViewController.self), sender: self)
        }
        else{
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
            availablityView.frame = CGRect.init(x: 0, y: 0, width: 170, height: 128)
            popover?.show(availablityView, fromView: sender as! UIView)
        }
    }
    
    
    //MARK: - utility
    
    func customizeUI(){
        detailView.darkShadow(withRadius: 5.0)
        availablityView.configure()
        availablityView.selectAvailability = {(result, error) in
            if error == nil{
                self.popover?.dismiss()
                self.selectAvailabilityStr = (result?.title)!
            }
        }
        
    }

    
    
}
