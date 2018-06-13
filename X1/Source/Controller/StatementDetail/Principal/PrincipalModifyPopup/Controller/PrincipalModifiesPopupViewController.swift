//
//  PrincipalModifiesPopupViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 12/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PrincipalModifiesPopupViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var principalPopUpTableView: UITableView!

    
    
    //MARK: - property
    struct PrincipalPopupOption {
        let title: String!;
        let iconImage: UIImage;
    }
    let popupTableHeaderHeight = 50.0;
    //MARK: - initializer
    
    var popupOptions: [PrincipalPopupOption] = [
        PrincipalPopupOption(title: NSLocalizedString("changeRating", comment: ""), iconImage: #imageLiteral(resourceName: "star")),
        PrincipalPopupOption(title: NSLocalizedString("changePriority", comment: ""), iconImage: #imageLiteral(resourceName: "clock")),
        PrincipalPopupOption(title: NSLocalizedString("changeLocation", comment: ""), iconImage: #imageLiteral(resourceName: "location"))
        
    ]
    

    //MARK: - view life cycle
    override func loadView() {
        super.loadView()
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
    
    //MARK: - action
    @IBAction func confirm(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ratingChanged(_ sender: UIButton) {
   
        let theIndexpath = IndexPath(row: 0, section: 0)
        if let cell = principalPopUpTableView.cellForRow(at: theIndexpath) as? PrincipalPopupTableCell {
//            let selectedExpertLevel = ExpertLevel(rawValue: sender.tag)!
            for  ratingButton in cell.ratingButtons {
                ratingButton.isSelected = sender.tag >= ratingButton.tag
            }
//            let rating                      = ExpertLevel(rawValue: sender.tag)!
//            let (name, subtitle)            = rating.description()
        }
        
       
    }
    
    
    
}


extension PrincipalModifiesPopupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PopUpHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50.0))
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = PopUpHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50.0))
//        let titleStr = "\(NSLocalizedString("priceQuote", comment: "")): $ 50.00"   ///replace its value
//        footerView.updateTitle(titleStr: titleStr)
//        return footerView
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = ReusableIdentifier.principalPopupTableCell
        let popupTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PrincipalPopupTableCell
        //Configure Cell....
        configure(cell: popupTableCell, indexPath: indexPath)
        
        return popupTableCell
    }
    
    
    func configure(cell: PrincipalPopupTableCell, indexPath: IndexPath)  {
        // UI configure
          let currentPopupOptions = popupOptions[indexPath.row];
        cell.iconImageView.image = currentPopupOptions.iconImage
        cell.titleLabel.text = currentPopupOptions.title
        if indexPath.row == 0 {
            cell.ratingView.isHidden = false;
            cell.optionDropdownButton.isHidden = true;
        }
        else{
            cell.ratingView.isHidden = true;
            cell.optionDropdownButton.isHidden = false;
            if indexPath.row == 1 {
                
            }
            else if (indexPath.row == 2){
                
            }
            
        }
        
        cell.selectionStyle = .none
    }
    
}



extension PrincipalModifiesPopupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(popupTableHeaderHeight);
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat(popupTableHeaderHeight);
//
//    }
    
}


