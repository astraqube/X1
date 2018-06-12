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
    let popupTableHeaderHeight = 50.0;

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

}


extension PrincipalModifiesPopupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PopUpHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50.0))
        return headerView
    }
    
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
    
    
}


