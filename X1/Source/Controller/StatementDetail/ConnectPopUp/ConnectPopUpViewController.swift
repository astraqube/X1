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
    @IBOutlet weak var tablePopUp: UITableView!
    
    //MARK: - other property

    
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
    
    @IBAction func actionSubmit(_ sender: Any) {
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
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "cell"
        var cell: PopUpCell! = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? PopUpCell
        if cell == nil {
            tableView.register(UINib(nibName: String(describing: PopUpCell.self), bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? PopUpCell
        }
        //Configure Cell....
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    func configure(cell: PopUpCell, indexPath: IndexPath)  {
        // UI configure
        
        
    }
    
}



extension ConnectPopUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70;
        }
        return 70;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0;
    }
}




