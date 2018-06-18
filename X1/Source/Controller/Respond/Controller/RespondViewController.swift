//
//  RespondViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 31/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import GrowingTextView
import Whisper

class RespondViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var problemStatementLabel: UILabel!
    @IBOutlet weak var responseTableView: UITableView!
    @IBOutlet weak var questionTextView: GrowingTextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addResponseButton: UIButton!
    @IBOutlet weak var problemStatementTextView: GrowingTextView!
    
    // MARK: - Submit Delegate
    
    weak var delegate:ResponseSubmitDelegate?
    
    // MARK: - Other Property
    
    var shouldOpenKeyboard = true
    var responses:[String] = []
    let webManager         = WebRequestManager()
    var user:User!
    var statement:Statement!
    var editingResponseIndex:Int?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeUI()
        setStatement()
        
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
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Set tableFooterView to remove extra lines
        responseTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        // Customize TextView
        questionTextView.layer.borderColor = UIColor.lightTheme().cgColor
        questionTextView.layer.borderWidth    = 2.0
        questionTextView.backgroundColor      = .clear
        
        submitButton.backgroundColor = .clear
        submitButton.darkShadow(withRadius: 5)
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 8
        submitButton.layer.backgroundColor = UIColor.white.cgColor
        submitButton.layer.sublayers?.last?.cornerRadius = 8.0
        submitButton.layer.sublayers?.last?.masksToBounds = true
        submitButton.layer.borderColor  = UIColor.lightTheme().cgColor
        submitButton.setTitleColor(UIColor.darkTheme(), for: .normal)
    }
    
    private func setStatement() {
        // Set selected statement data
        problemStatementTextView.text = "\"" + statement.problemText + "\""
    }
    
    private func enableSubmitButton() {
        // Enable/disable submit button
        if responses.count > 0 || !questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            submitButton.isEnabled = true
            submitButton.alpha     = 1.0
        }
        else {
            submitButton.isEnabled = false
            submitButton.alpha     = 0.5
        }
    }
    
    private func showAlert(with title:String, message: String) {
        // Show alert to user
        let announcement = Announcement(title: title, subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
            
        })
    }
    
    private func isValidQuestion(with text: String) -> Bool {
        let isQuestion = text.contains("?")
        if isQuestion {
            if text.components(separatedBy: "?").count > 2 {
                // Show alert for more than 1 question
                showAlert(with: NSLocalizedString("multipleQuestionTitle", comment: ""), message: NSLocalizedString("multipleQuestionMessage", comment: ""))
                return false
            }
            return true
        }
        else {
            // Show alert for no question
            showAlert(with: NSLocalizedString("invalidQuestionTitle", comment: ""), message: NSLocalizedString("invalidQuestionMessage", comment: ""))
        }
        return false
    }
    
    // MARK: - IB Action
    
    @IBAction func close(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func editResponse(_ sender: UIButton) {
        // Check if the cell was being edited already
        if questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Proceed with editing
            if responses.count > sender.tag {
                let response                 = responses[sender.tag]
                addResponseButton.isSelected = true
                questionTextView.text        = response
                editingResponseIndex         = sender.tag
            }
        }
        else {
            // Show alert that user has unfinished business
            questionTextView.shake()
        }
    }
    
    
    @IBAction func submitResponse(_ sender: Any) {
        // Check for any editing text
        guard !activityIndicator.isAnimating else {
            return
        }
        let text = questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            addQuestion(sender)
        }
        if responses.count > 0 {
            // Post the response
            let parameters = [PostStatementKey.response: responses]
            requestSubmit(with: parameters)
        }
    }
    
    
    @IBAction func addQuestion(_ sender: Any) {
        // Insert a new row for a question
        let text = questionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidQuestion(with: text) else {
            return
        }
        if !text.isEmpty {
            if let editingTextRow = editingResponseIndex {
                // Edit the text at index path and reload that row
                addResponseButton.isSelected = false
                editingResponseIndex = nil
                responses.remove(at: editingTextRow)
                responses.insert(text, at: editingTextRow)
                responseTableView.reloadData()
            }
            else {
                addNewRow(with: text)
            }
            questionTextView.text = nil
        }
        else {
            questionTextView.shake()
        }
        
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
            setMaxHeightForTextView(with: keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        responseTableView.contentInset = UIEdgeInsets.zero
        setMaxHeightForTextView(with: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       
    }
    
    func textViewDidChange(_ textView: UITextView) {
        enableSubmitButton()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    @objc func scrollTableView() {
    }
    
    private func setMaxHeightForTextView(with keyboardHeight:CGFloat) {
        // Set maximum height for text view
        let availableHeight = (self.view.frame.size.height - questionTextView.frame.origin.y) - keyboardHeight
        questionTextView.maxHeight =  availableHeight > 200 ? 200 : availableHeight
    }
    
}

extension RespondViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - TableView Datasource and Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return responses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.addResponseTableCell, for: indexPath) as! AddResponseTableViewCell
        if responses.count > indexPath.row {
            tableViewCell.questionLabel.text         = responses[indexPath.row]
            tableViewCell.editButton.tag             = indexPath.row
            tableViewCell.questionCountLabel.text    = NSLocalizedString("question", comment: "") + " \(responses.count - indexPath.row)"
        }
        return tableViewCell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - TableView Row Management
    
    fileprivate func addNewRow(with text: String) {
        // Insert a new row
        responses.insert(text, at: 0)
        let indexPath = IndexPath.init(row: 0, section: 0)
        responseTableView.insertRows(at: [indexPath], with: .left)
        perform(#selector(refreshTableView), with: nil, afterDelay: 0.5)
    }
    
    fileprivate func deleteRow(at indexPath:IndexPath) {
        if responses.count > indexPath.row {
            responses.remove(at: indexPath.row)
            responseTableView.deleteRows(at: [indexPath], with: .right)
            perform(#selector(refreshTableView), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc fileprivate func refreshTableView() {
        responseTableView.reloadData()
    }
}

extension RespondViewController {
    
    // MARK: - Network Request
    
    fileprivate func requestSubmit(with parameters: Dictionary<String, Any>) {
        // Network request
        let apiEndPoint = APIEndPoint.submitResponse(with: user.userId, statementId: statement.identifier)
        let apiURL      = APIURL.statementUrl(apiEndPoint: apiEndPoint)
        weak var weakSelf = self
        webManager.httpRequest(method: .post, apiURL: apiURL, body: parameters, completion: { (response) in
            // Response was submitted successfully
            weakSelf?.didSubmitResponse()
        }) { (error) in
            weakSelf?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Request Completion
    
    fileprivate func didSubmitResponse() {
        // Respose submitted
        activityIndicator.stopAnimating()
        delegate?.didSubmitResponse(self, statement: statement)
        dismiss(animated: true) {
            
        }
    }
}

protocol ResponseSubmitDelegate:class {
    func didSubmitResponse(_ respondViewController: RespondViewController, statement: Statement)
}
