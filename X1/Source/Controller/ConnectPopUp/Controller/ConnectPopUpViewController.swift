//
//  ConnectPopUpViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 07/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ConnectPopUpViewController: UIViewController {

    //MARK: - outlet
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupTableViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: - other property
    var options: [ConnectOptions] = [
        ConnectOptions.init(name: NSLocalizedString("solve", comment: ""), selected: false),
        ConnectOptions(name: NSLocalizedString("provideFeedback", comment: ""), selected : false),
        ConnectOptions(name: NSLocalizedString("lacksDetail", comment: ""), selected : false)
    ]
    
    let cellHeight = 60.0
    let expandedHeightOfCell = 140.0
    let popupTableHeight = 250.0;
    let popupTableHeaderHeight = 50.0;
    var isShareViaEmail = true;

    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - button actions
    @IBAction func submit(_ sender: Any) {
          self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - utility
    
    private func customizeUI() {
        // Customize for theme appearance
        
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = UIColor.lightTheme().cgColor
        submitButton.darkShadow(withRadius: 5)
        
    }

}


extension ConnectPopUpViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PopUpHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50.0))
//        headerView.titleView.darkShadowInside()
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = ReusableIdentifier.popUpTableCell
        let popupTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PopUpCell

        //Configure Cell....
        configure(cell: popupTableCell, indexPath: indexPath)
        popupTableCell.selectionStyle = .none
        return popupTableCell
    }
    
    
    func configure(cell: PopUpCell, indexPath: IndexPath)  {
        // UI configure
        let connectOptions = options[indexPath.row]
        cell.titleLabel.text = connectOptions.name;
        cell.checkBoxButton.isSelected = connectOptions.isSelected
        cell.checkBoxButton.tag = indexPath.row;
        cell.checkBoxButton.addTarget(self, action: #selector(selectCheckbox(sender:)), for: UIControlEvents.touchUpInside)
        
          UIView.animate(withDuration: 0.8) {
        
            if indexPath.row == 0 && connectOptions.isSelected {
                cell.solveSubView.isHidden = false;
                cell.shareViaEmailButton.isSelected = self.isShareViaEmail;
                cell.shareViaConferenceCallButton.isSelected = !self.isShareViaEmail;
                
    //            cell.shareViaEmailButton.tag = 0
    //            cell.shareViaConferenceCallButton.tag = 1
                cell.shareViaEmailButton.addTarget(self, action: #selector(self.shareVia(sender:)), for: UIControlEvents.touchUpInside)
                cell.shareViaConferenceCallButton.addTarget(self, action: #selector(self.shareVia(sender:)), for: UIControlEvents.touchUpInside)

                
                if self.isShareViaEmail {
                    cell.solveViaConferenceTopConstraint.constant = 50.0
                    cell.selectDurationTopConstraint.constant = 10.0
                   cell.shareViaEmailView.backgroundColor = UIColor.lightGrayTheme()
                }
                else{
                    cell.solveViaConferenceTopConstraint.constant = 10.0
                    cell.selectDurationTopConstraint.constant = 50.0
                    cell.shareViaConferenceView.backgroundColor = UIColor.lightGrayTheme()

                }
                cell.contentView.layoutIfNeeded()
            }
            else{
                cell.solveSubView.isHidden = true;
            }
        }
        
    }
    
    //MARK: - table action
    @objc func selectCheckbox(sender: UIButton) {
        let connectOptions = options[sender.tag]
        connectOptions.isSelected = !connectOptions.isSelected
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        
        UIView.animate(withDuration: 0.8) {
            self.popupTableView.reloadRows(at: [selectedIndexPath], with: .fade);
        }
        

    }
    
    @objc func shareVia(sender: UIButton) {
        self.isShareViaEmail = !self.isShareViaEmail
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        UIView.animate(withDuration: 0.8) {
            self.popupTableView.reloadRows(at: [selectedIndexPath], with: .fade);
        }
    }
    
    
}



extension ConnectPopUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        UIView.animate(withDuration: 0.8) {
            self.updateHeightOfTableView()
        }
 
        let connectOptions = options[indexPath.row]
        if indexPath.row == 0 && connectOptions.isSelected{
            return CGFloat(cellHeight + expandedHeightOfCell)
        }
//        return UITableViewAutomaticDimension;
        return CGFloat(cellHeight);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(popupTableHeaderHeight);
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        UIView.animate(withDuration: 0.4) {
//            cell.transform = CGAffineTransform.identity
//        }
//    }

    func updateHeightOfTableView(){
         let connectOptions = options[0]
        if connectOptions.isSelected {
            self.popupTableViewHeightConstraint.constant = CGFloat(popupTableHeight + expandedHeightOfCell)
        }
        else{
            self.popupTableViewHeightConstraint.constant = CGFloat(popupTableHeight)
        }
        self.view.layoutIfNeeded()
    }
}




