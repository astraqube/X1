//
//  NotificationViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 11/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var notificationsTableView: UITableView!
    
    //MARK: - Property
    private var user = User.loggedInUser()

    
    // MARK: - View Life Cycle

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
    @IBAction func openMenu(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    

    private func navigateToConsult() {
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryboardName.meetingFlow, bundle:nil)
        var nextViewController : UIViewController?
        if user?.type == .principal {
            nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: PrincipalStatementDetailViewController.self)) as! PrincipalStatementDetailViewController
        }
        else{
            nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: StatementDetailViewController.self)) as! StatementDetailViewController
        }
        self.present(nextViewController!, animated:true, completion:nil)
    }
    
    
    
}


extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
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
        
        let fontSize = 14.0
        
        let orangefont = [ NSAttributedStringKey.font: UIFont.robotoFont(wityType: .bold, size: CGFloat(fontSize)) , NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.3098039216, blue: 0.02352941176, alpha: 1)] as [NSAttributedStringKey : Any]
        let blackFont = [NSAttributedStringKey.font : UIFont.robotoFont(wityType: .regular, size: CGFloat(fontSize)) , NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)] as [NSAttributedStringKey : Any]
        

        let userName = NSMutableAttributedString(string: "@spidy_Kid ", attributes: orangefont)   // change with model
        let notificationDetail = NSMutableAttributedString(string: "has confirmed the consultation", attributes: blackFont)   // change with model
       
        
        let completeAttributedStr = NSMutableAttributedString();
        completeAttributedStr.append(userName)
        completeAttributedStr.append(notificationDetail)
        cell.titleLabel.attributedText = completeAttributedStr;
        if indexPath.row > 1 {
            cell.detailView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.8196078431, blue: 0.8235294118, alpha: 1)
        }
        else{
            cell.detailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        
    }
    
}



extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToConsult()
    }
    
}


