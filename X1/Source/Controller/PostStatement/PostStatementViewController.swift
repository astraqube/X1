//
//  PostStatementViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 18/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import ALCameraViewController
import M13Checkbox

class PostStatementViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var statmentTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postStatementButton: UIButton!
    @IBOutlet weak var viewSimilarStatementButton: UIButton!
    var accessoryView:KeyboardAccessory!
    
    @IBOutlet weak var checkBoxView: M13Checkbox!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        postStatementButton.backgroundColor = .clear
        postStatementButton.darkShadow(withRadius: 5)
        postStatementButton.layer.borderWidth = 1.0
        postStatementButton.applyGradient(colours: [UIColor.lightTheme(), UIColor.darkTheme()])
        postStatementButton.layer.cornerRadius = 8
        postStatementButton.layer.sublayers?.last?.cornerRadius = 8.0
        postStatementButton.layer.sublayers?.last?.masksToBounds = true
        postStatementButton.layer.borderColor  = UIColor.lightTheme().cgColor
        postStatementButton.setTitleColor(.white, for: .normal)
        postStatementButton.alpha = 0.5
        postStatementButton.isEnabled = false
        
        viewSimilarStatementButton.backgroundColor = .clear
        viewSimilarStatementButton.darkShadow(withRadius: 5)
        viewSimilarStatementButton.layer.borderWidth = 1.0
        viewSimilarStatementButton.layer.backgroundColor = UIColor.white.cgColor
        viewSimilarStatementButton.layer.cornerRadius = 8
        viewSimilarStatementButton.layer.borderColor  = UIColor.lightTheme().cgColor
        viewSimilarStatementButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        
        containerView.backgroundColor = .clear
        containerView.darkShadow(withRadius: 10)
        containerView.layer.backgroundColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 8
        
        setupKeyboardAccesory()
    }
    
    private func setupKeyboardAccesory() {
        // Set Keyboard Accessory
        accessoryView   = KeyboardAccessory.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        accessoryView.delegate = self
        accessoryView.leftButton.isHidden = true
        accessoryView.rightButton.isHidden = true
        statmentTextView.inputAccessoryView = accessoryView
    }
    
    // MARK: - Button Action
    
    @IBAction func postStatement(_ sender: Any) {
        showActivity()
    }
    
    @IBAction func viewSimilarStatement(_ sender: Any) {
    }
    
    @IBAction func closeController(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        // Add image to the question
        openPhotos()
    }
    
    @IBAction func selectRating(_ sender: Any) {
    }
    
    @IBAction func addCategories(_ sender: Any) {
    }
    
    @IBAction func addDuration(_ sender: Any) {
    }
    
    
    @IBAction func didTapOnEmptyArea(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }

}

extension PostStatementViewController: KeyboardAccessoryDelegate, UITextViewDelegate {
    
    // MARK: - Keyboard Accessory Delegate
    
    func keyboardAction(type: KeyboardAccessoryButton) {
        view.endEditing(true)
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            postStatementButton.alpha       = 0.5
            postStatementButton.isEnabled   = false
            placeholderLabel.isHidden       = false
        }
        else {
            postStatementButton.alpha       = 1.0
            postStatementButton.isEnabled   = true
            placeholderLabel.isHidden       = true
        }
    }
    
}

extension PostStatementViewController {
   
    // MARK: - Image Picker
    
    func openPhotos() {
        // Open camera or photos
        let croppingParameters = CroppingParameters.init(isEnabled: true, allowResizing: true, allowMoving: true)
        weak var weakSelf = self
        let cameraController = CameraViewController.init(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { (image, asset) in
            // Dismiss controller
            weakSelf?.dismiss(animated: true, completion: {
                if let selectedImage = image {
                    // If image was selected
                    weakSelf?.didPickImage(image: selectedImage)
                }
            });
        }
        
        present(cameraController, animated: true) {
            
        }
    }
    
    func didPickImage(image:UIImage) {
        // Add the selected image as attachment
        let resizedImage = image.resize(byWidth: 200)
        let fullString = NSMutableAttributedString(string: statmentTextView.text + "\n\n")
        fullString.setAttributes([NSAttributedStringKey.font : statmentTextView.font!], range: NSRange.init(location: 0, length: fullString.length))
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect.init(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
         let stringWithAttachment = NSAttributedString(attachment: attachment)
        fullString.append(stringWithAttachment)
        statmentTextView.attributedText = fullString
    }
    
    func showActivity() {
        blurView.isHidden = false
        activityIndicator.startAnimating()
        perform(#selector(showCheckMark), with: nil, afterDelay: 3)
    }
    
    @objc func showCheckMark() {
        checkBoxView.isHidden = false
        checkBoxView.tintColor = UIColor.darkTheme()
        checkBoxView.animationDuration = 2.0
        checkBoxView.stateChangeAnimation = .stroke
        checkBoxView.setCheckState(.checked, animated: true)
        
        activityIndicator.stopAnimating()
        perform(#selector(closeView), with: nil, afterDelay: 2)
    }
    
    @objc func closeView() {
        dismiss(animated: true) {
            
        }
    }
}
