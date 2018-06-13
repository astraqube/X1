//
//  ConfirmedPopupViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 13/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ConfirmedPopupViewController: UIViewController {

    //MARK: - outlet
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var userDetailLabel: UILabel!
    
    //MARK: - view life cycle
    
    override func loadView() {
        super.loadView()
        customizeUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissPopup()
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
    
    //MARK: - Dismiss auto View controller
    func dismissPopup(){
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - utility
    func customizeUI(){
        
        detailView.layer.borderWidth = 1.0
        detailView.layer.borderColor = UIColor.lightTheme().cgColor
        detailView.darkShadow(withRadius: 5)
        
        
        
        let boldFontSize = 16.0
        
        let boldFontAttribute = [ NSAttributedStringKey.font: UIFont.robotoFont(wityType: .bold, size: CGFloat(boldFontSize)) , NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)] as [NSAttributedStringKey : Any]
        let regulerFontAttribute = [NSAttributedStringKey.font : UIFont.robotoFont(wityType: .regular, size: CGFloat(boldFontSize)) , NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1)] as [NSAttributedStringKey : Any]

        let userHeading = NSLocalizedString("user", comment: "")
        let userHeadingAttributed = NSMutableAttributedString(string: "\(userHeading) :", attributes: boldFontAttribute)
        let userName = NSMutableAttributedString(string: "@spidy_Kid\n", attributes: regulerFontAttribute)   // change with model

        
        let methodHeading = NSLocalizedString("method", comment: "")
        let methodHeadingAttributed = NSMutableAttributedString(string: "\(methodHeading) :", attributes: boldFontAttribute)
        let methodName = NSMutableAttributedString(string: "Solve via E-mail\n", attributes: regulerFontAttribute)   // change with model

        let emailIdHeading = NSLocalizedString("emailId", comment: "")
        let emailIdHeadingAttributed = NSMutableAttributedString(string: "\(emailIdHeading) :", attributes: boldFontAttribute)
        let email = NSMutableAttributedString(string: "spidy_kid@gmail.com\n", attributes: regulerFontAttribute)   // change with model

        let timingsHeading = NSLocalizedString("timings", comment: "")
        let timingsHeadingAttributed = NSMutableAttributedString(string: "\(timingsHeading) :", attributes: boldFontAttribute)
         let timing = NSMutableAttributedString(string: "1:00 PM - 1:30 PM", attributes: regulerFontAttribute)    // change with model
        
        
        let completeAttributedStr = NSMutableAttributedString();
        completeAttributedStr.append(userHeadingAttributed)
        completeAttributedStr.append(userName)
        completeAttributedStr.append(methodHeadingAttributed)
        completeAttributedStr.append(methodName)
        completeAttributedStr.append(emailIdHeadingAttributed)
        completeAttributedStr.append(email)
        completeAttributedStr.append(timingsHeadingAttributed)
        completeAttributedStr.append(timing)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = NSTextAlignment.center
        completeAttributedStr.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, completeAttributedStr.length))

        self.userDetailLabel.attributedText = completeAttributedStr;
    }

}
