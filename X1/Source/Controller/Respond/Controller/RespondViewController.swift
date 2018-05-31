//
//  RespondViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 31/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RespondViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var problemStatementLabel: UILabel!
    @IBOutlet weak var responseTableView: UITableView!
    fileprivate var editingTextView:UITextView?
    
    
    // MARK: - Other Property
    
    var shouldOpenKeyboard = true
    var responses:[String] = [""]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeUI()
        
        // Add notification to observe Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        // Remove Keyboard observer before it gets deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    // MARK: Utility
    
    private func customizeUI() {
        // Set tableFooterView to remove extra lines
        responseTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    // MARK: - IB Action
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    
    
    @IBAction func addQuestion(_ sender: Any) {
        // Insert a new row for a question
        addNewRow()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
    }

}

extension RespondViewController: UITextViewDelegate {
    
    // MARK: - Keyboard Notification
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            responseTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
//        perform(#selector(scrollTableView), with: self, afterDelay: 1.0)
        
        let indexPath = IndexPath.init(row: editingTextView!.tag, section: 0)
        responseTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        responseTableView.contentInset = UIEdgeInsets.zero
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? UITableViewCell,
            let indexPath = responseTableView.indexPath(for: cell) {
            responseTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        editingTextView = textView
        return true
    }
    
    @objc func scrollTableView() {
        let indexPath = IndexPath.init(row: editingTextView!.tag, section: 0)
        responseTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension RespondViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - TableView Datasource and Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return responses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.addResponseTableCell, for: indexPath) as! AddResponseTableViewCell
        if shouldOpenKeyboard {
            shouldOpenKeyboard = false
            tableViewCell.questionTextView.becomeFirstResponder()
        }
        tableViewCell.questionTextView.tag = indexPath.row
        return tableViewCell
    }
    
    // MARK: - TableView Row Management
    
    fileprivate func addNewRow() {
        // Insert a new row
        responses.insert("", at: 0)
        let indexPath = IndexPath.init(row: 0, section: 0)
        responseTableView.insertRows(at: [indexPath], with: .left)
    }
    
}
