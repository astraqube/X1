//
//  StatementDetailViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 07/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Popover

class StatementDetailViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var buttonConnect: UIButton!
    @IBOutlet var warningView: UIView!
    
    var popover:Popover?

    //MARK: - Properties
    
    //MARK: - view life cycle
    
    override func loadView() {
        super.loadView()
        self.configureDetailScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDetailScreen(){
        self.customizeUI()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == String(describing: ConnectPopUpViewController.self)){
            if let connectPopup = segue.destination as? ConnectPopUpViewController {
                connectPopup.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }
        }
    }
    

//MARK: - actions

    @IBAction func goBack(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func connectStatement(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: ConnectPopUpViewController.self), sender: self)
    }
    
    @IBAction func tapFlag(_ sender: Any) {
        
                popover?.dismiss()
                popover = nil
                let options = [
                    .type(.down),
                    .cornerRadius(5),
                    .animationIn(0.3),
                    .blackOverlayColor(UIColor.lightGray.withAlphaComponent(0.3)),
                    .arrowSize(CGSize.init(width: 10, height: 10))
                    ] as [PopoverOption]
                popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
//                warningView.frame = CGRect.init(x: 0, y: 0, width: 240, height: 128)
        popover?.show(warningView, fromView: sender as! UIView)
        
    }
    
   
    //MARK: - utility
    
    private func customizeUI() {
        // Customize for theme appearance
        self.detailView.darkShadow(withRadius: 10.0, color: UIColor.black.withAlphaComponent(0.3))
        buttonConnect.layer.borderWidth = 1.0
        buttonConnect.layer.borderColor = UIColor.lightTheme().cgColor
        buttonConnect.darkShadow(withRadius: 5)
       
    }
    
}
