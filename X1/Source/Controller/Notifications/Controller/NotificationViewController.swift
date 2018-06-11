//
//  NotificationViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 11/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - outlets
    @IBOutlet weak var notificationsTableView: UITableView!
    
    
    
    //MARK: - view life cycle

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


extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.notificationTableCell, for: indexPath) as! NotificationsTableCell
        
        //Configure Cell....
        configure(cell: tableViewCell, indexPath: indexPath)
        tableViewCell.selectionStyle = .none
        return tableViewCell
    }
    
    
    func configure(cell: NotificationsTableCell, indexPath: IndexPath)  {
        // UI configure
        
        
        
        //Update data on cell
        cell.textLabel?.text = "Cell..."
        
    }
    
}



extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}


