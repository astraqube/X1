//
//  ViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 06/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        configureNavigationBar()
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
    func configureNavigationBar(){
//        navigationController?.navigationBar.barTintColor = UIColor.lightTheme()
        self.navigationItem.title = screenTitle() as String
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    //MARK: - screen title
    func screenTitle() -> String {
        let className = NSStringFromClass(type(of: self))
        var screenTitle = className.replacingOccurrences(of: "ViewController", with: "")
        screenTitle = screenTitle.replacingOccurrences(of: "Solviant.", with: "")
        return screenTitle as String;
    }
    

}
