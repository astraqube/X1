//
//  ProfileViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 01/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import ALCameraViewController
import Whisper

class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet weak var profileTableView: UITableView!
    weak var editingTextField:UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var oneMomentLabel: UILabel!
    
    // MARK: - Other Property
    
    let webManager           = WebRequestManager()
    var user:User!
    let rowsInSection        = [1, 8, 1]
    let placeholders         = ["gender", "dob", "mobile", "addressLine", "city", "state", "country", "zip" ]
    let rowHeights:[CGFloat] = [103, 73, 87]
    var accessoryView:KeyboardAccessory!
    var datePicker           = UIDatePicker()
    let genderPicker         = UIPickerView()
    let locationManager      = LocationManager()
    var genderDatasource     = ["selectGender", "male", "female", "unisex"]
    enum ProfileSection:Int {
        case userImage
        case textField
        case actionButton
    }
    enum TextFieldRow:Int {
        case gender
        case dob
        case mobile
        case address
        case city
        case state
        case country
        case zip
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add notification to observe Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Customize UI for theme appearance
        customizeUI()
        
        // Get user's current location from GPS
        currentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // Remove Keyboard observer before it gets deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Setup keyboard accessory view for swtiching between textfields
        setupKeyboardAccesory()
    }
    
    private func currentLocation() {
        // Fetch current location and set values
        weak var weakSelf = self
        locationManager.currentLocation(location: { (latitude, longitude) in
            // Received latitue and longitude
            weakSelf?.user.latitude  = latitude
            weakSelf?.user.longitude = longitude
            weakSelf?.locationManager.stopLocationUpdate()
            weakSelf?.locationManager.reverseGeocode(latitude: latitude, longitude: longitude, completion: { (address) in
                // Physical address of the current location
                weakSelf?.didFetchCurrentLocation(address)
            })
        }) { (status) in
            // Check if permission was granted
        }
    }
    
    private func showAlert(withMessage message: String) {
        // Show alert to user
        let announcement = Announcement(title: NSLocalizedString("unableToProceed", comment: "") , subtitle: message, image: #imageLiteral(resourceName: "info"))
        Whisper.show(shout: announcement, to: self, completion: {
            
        })
    }
    
    private func didFetchCurrentLocation(_ address: Address) {
        // Set address
        user.addressLine = address.addressLine
        user.city        = address.city
        user.state       = address.state
        user.country     = address.country
        user.zipCode     = address.zip
        user.latitude    = address.latitude
        user.longitude   = address.longitude
        
        profileTableView.reloadData()
    }
    
    // MARK: - Validation
    
    private func isValid() -> Bool {
        // Validate required textfields
        
        // Embedded function to set error messages
        
        func setError(rowIndex: Int, message: String) {
            let indexPath = IndexPath.init(row: rowIndex, section: ProfileSection.textField.rawValue)
            if let textFieldCell = profileTableView.cellForRow(at: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is visible
                textFieldCell.inputTextField.becomeFirstResponder()
                textFieldCell.inputTextField.errorMessage = message
            }
            else if let textFieldCell = profileTableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileTextFieldCell, for: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is not visible
                textFieldCell.inputTextField.becomeFirstResponder()
                textFieldCell.inputTextField.errorMessage = message
            }
        }
        
        // 1. Validate mobile number
        if let cellNumber = user.cellNumber, !cellNumber.isEmpty {
            if !cellNumber.isValidMobile() {
                // Set error message
                setError(rowIndex: TextFieldRow.mobile.rawValue, message: NSLocalizedString("invalidMobile", comment: ""))
                return false
            }
        }
        
        // 2. DOB Validation
        
        if let dob = user.dob, !dob.isEmpty {
            if !dob.isValidDob() {
                // Set error message
                setError(rowIndex: TextFieldRow.dob.rawValue, message: NSLocalizedString("underage", comment: ""))
                return false
            }
        }
        
        return true
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: Any) {
        guard  !activityIndicator.isAnimating else {
            return
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func completeProfile(_ sender: Any) {
        // Validate textfields
        guard  !activityIndicator.isAnimating else {
            return
        }
        let status = isValid()
        if status {
            // Network request to create an account (Complete profile now)
            let parameters = user.parameter()
            requestSignUp(withParameters: parameters)
        }
    }
    
    @objc func changeImage(_ sender: Any) {
        guard  !activityIndicator.isAnimating else {
            return
        }
        openPhotos()
    }
    
    @objc func didPickDate(sender: UIDatePicker) {
        let dob     = sender.date.dobDisplayFormat()
        user.dob    = dob
        editingTextField.text = dob
        (editingTextField as! SkyFloatingLabelTextField).errorMessage = nil
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
    private func gotoHomeScreen(forUser user: User) {
        // Move to next screen after Sign Up
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.home) as? HomeViewController {
            homeViewController.user = user
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}

extension ProfileViewController: KeyboardAccessoryDelegate {
    
    // Keyboard extension
    
    // MARK: - Keyboard Notification
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            profileTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        profileTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func setupKeyboardAccesory() {
        // Set Keyboard Accessory
        accessoryView   = KeyboardAccessory.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        accessoryView.delegate = self
        
        // Setup Date Picker for DOB Selection
        datePicker.datePickerMode = .date
        datePicker.maximumDate    = Date()
        datePicker.addTarget(self, action: #selector(didPickDate(sender:)), for: .valueChanged)
        
        // Setup Gender Picker
        genderPicker.dataSource = self
        genderPicker.delegate   = self
    }
    
    // MARK: - Acceessory Delegate
    
    func keyboardAction(type: KeyboardAccessoryButton) {
        switch type {
        case .leftButton:
            prevResponder()
            break
        case .rightButton:
            nextResponder()
            break
        default:
            view.endEditing(true)
        }
    }
    
    func nextResponder() {
        // Go to next textfield
        let nextCellTag = self.editingTextField.tag + 1
        if nextCellTag < profileTableView.numberOfRows(inSection: ProfileSection.textField.rawValue) {
            // Not the last cell
            let indexPath = IndexPath.init(row: nextCellTag, section: ProfileSection.textField.rawValue)
            if let textFieldCell = profileTableView.cellForRow(at: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is visible
                textFieldCell.inputTextField.becomeFirstResponder()
            }
            else if let textFieldCell = profileTableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileTextFieldCell, for: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is not visible
                textFieldCell.inputTextField.becomeFirstResponder()
            }
        }
        else {
            view.endEditing(true)
        }
    }
    
    func prevResponder() {
        // Go to prev textfield
        let prevCellTag = self.editingTextField.tag - 1
        if prevCellTag >= 0 {
            // Not the first cell
            let indexPath = IndexPath.init(row: prevCellTag, section: ProfileSection.textField.rawValue)
            if let textFieldCell = profileTableView.cellForRow(at: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is visible
                textFieldCell.inputTextField.becomeFirstResponder()
            }
            else if let textFieldCell = profileTableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileTextFieldCell, for: indexPath) as? ProfileTextFieldTableViewCell {
                // If cell is not visible
                textFieldCell.inputTextField.becomeFirstResponder()
            }
        }
        else {
            view.endEditing(true)
        }
    }
}

extension ProfileViewController {
    // MARK: - Image Picker
    
    func openPhotos() {
        // Open camera or photos
        let croppingParameters = CroppingParameters.init(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize.init(width: 300, height: 300))
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
        // User selected image
        let indexPath        = IndexPath.init(row: 0, section: 0)
        if let tableViewCell = profileTableView.cellForRow(at: indexPath) as? ProfileUserImageTableViewCell {
            tableViewCell.userImageView?.image = image
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !activityIndicator.isAnimating
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let inputTextField  = textField as? SkyFloatingLabelTextField {
            inputTextField.errorMessage = nil
        }
        editingTextField = textField
    }
    
    @IBAction func textFieldEditingChanged(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = nil
        let trimmedText = sender.text?.trimmingCharacters(in: .whitespaces)
        if let textFieldRow = TextFieldRow(rawValue: sender.tag) {
            switch textFieldRow {
            case .gender:
                user.gender = sender.text
            case .dob:
                user.dob = sender.text
            case .mobile:
                user.cellNumber = trimmedText
            case .address:
                user.addressLine = trimmedText
            case .city:
                user.city = trimmedText
            case .state:
                user.state = trimmedText
            case .country:
                user.country = trimmedText
            case .zip:
                user.zipCode = trimmedText
            }
        }
    }
}

extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - PickerView Datasource and Delegate
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderDatasource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(genderDatasource[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            let gender = NSLocalizedString(genderDatasource[row], comment: "")
            editingTextField.text = gender
            user.gender           = gender
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView Datasource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell!
        let section = ProfileSection(rawValue: indexPath.section)!
        switch section {
        case .userImage:
            // For user images
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileImageViewCell, for: indexPath)
            if tableViewCell.tag == 0, let userImageViewCell = tableViewCell as? ProfileUserImageTableViewCell {
                tableViewCell.tag = 1 // Tag is set so that we don't add gesture every time
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(changeImage(_:)))
                userImageViewCell.addGestureRecognizer(tapGesture)
            }
        case .textField:
            // For text field cells
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileTextFieldCell, for: indexPath)
            // Set placeholders for text field
            if let textFieldCell = tableViewCell as? ProfileTextFieldTableViewCell {
                textFieldCell.inputTextField.placeholder = NSLocalizedString(placeholders[indexPath.row], comment: "")
                textFieldCell.inputTextField.inputAccessoryView = accessoryView
                textFieldCell.inputTextField.tag = indexPath.row
                if let textFieldType = TextFieldRow(rawValue: indexPath.row) {
                    switch textFieldType {
                    case .dob:
                        textFieldCell.inputTextField.inputView = datePicker
                        textFieldCell.inputTextField.text      = user.dob
                    case .gender:
                        textFieldCell.inputTextField.inputView = genderPicker
                        textFieldCell.inputTextField.text      = user.gender
                    case .mobile:
                        textFieldCell.inputTextField.returnKeyType = .next
                        textFieldCell.inputTextField.textContentType = UITextContentType.telephoneNumber
                        textFieldCell.inputTextField.keyboardType    = .phonePad
                        textFieldCell.inputTextField.text            = user.cellNumber
                    case .address:
                        textFieldCell.inputTextField.returnKeyType = .next
                        textFieldCell.inputTextField.textContentType = UITextContentType.streetAddressLine1
                        textFieldCell.inputTextField.keyboardType    = .default
                        textFieldCell.inputTextField.text            = user.addressLine
                    case .city:
                        textFieldCell.inputTextField.returnKeyType = .next
                        textFieldCell.inputTextField.textContentType = UITextContentType.addressCity
                        textFieldCell.inputTextField.keyboardType    = .default
                        textFieldCell.inputTextField.text            = user.city
                    case .state:
                        textFieldCell.inputTextField.returnKeyType = .next
                        textFieldCell.inputTextField.textContentType = UITextContentType.addressState
                        textFieldCell.inputTextField.keyboardType    = .default
                        textFieldCell.inputTextField.text            = user.state
                    case .country:
                        textFieldCell.inputTextField.returnKeyType = .next
                        textFieldCell.inputTextField.textContentType = UITextContentType.countryName
                        textFieldCell.inputTextField.keyboardType    = .default
                        textFieldCell.inputTextField.text            = user.country
                    case .zip:
                        textFieldCell.inputTextField.returnKeyType = .done
                        textFieldCell.inputTextField.textContentType = UITextContentType.postalCode
                        textFieldCell.inputTextField.keyboardType    = .default
                        textFieldCell.inputTextField.text            = user.zipCode
                    }
                }
            }
        case .actionButton:
            // For Action Button
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileDoneButtonCell, for: indexPath)
        }
        return tableViewCell
    }
}

extension ProfileViewController {
    // MARK: - Network Request
    
    private func requestSignUp(withParameters parameters: Dictionary<String, Any>) {
        // Create user account using filled details
        activityIndicator.startAnimating()
        weak var weakSelf = self
        oneMomentLabel.isHidden = false
        activityIndicator.startAnimating()
        let url = APIURL.url(apiEndPoint: APIEndPoint.signUp)
        webManager.httpRequest(method: .post, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.didSignUp(withResponse: response)
        }) { (error) in
            // Request failed
            weakSelf?.oneMomentLabel.isHidden = true
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.showAlert(withMessage: NSLocalizedString("unexpectedErrorMessage", comment: ""))
        }
    }
    
    // MARK: - Request Completion
    
     private func didSignUp(withResponse response: Dictionary<String, Any>) {
        activityIndicator.stopAnimating()
        oneMomentLabel.isHidden = true
        if let statusCode = response[APIKeys.status] as? String {
            if statusCode == HTTPStatus.success {
                // User registered successfully
                guard let result = response[APIKeys.result] as? Dictionary<String, Any>,
                    let userInfo = result[APIKeys.userInfo] as? Dictionary<String, Any>,
                    let userId   = userInfo[UserKey.userId] as? String,
                    let accessToken = result[UserKey.accessToken] as? String else {
                        return
                }
                user.accessToken = accessToken
                user.userId      = userId
                user.save() // Save user details
                
                // Go to next screen
                gotoHomeScreen(forUser: user)
            }
        }
        else if let errorMessage = response[APIKeys.errorMessage] as? String {
            // Show  error
            showAlert(withMessage: errorMessage)
        }
    }
}
