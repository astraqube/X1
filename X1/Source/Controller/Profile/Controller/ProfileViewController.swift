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
import CountryPicker

class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet weak var profileTableView: UITableView!
    weak var editingTextField:UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var oneMomentLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - Other Property
    
    var isEditingProfile     = true
    var picker:CountryPicker!
    let webManager           = WebRequestManager()
    var user:User!
    let rowsInSection        = [1, 1, 8, 1]
    let placeholders         = ["name","gender", "dob", "addressLine", "city", "state", "country", "zip" ]
    let rowHeights:[CGFloat] = [103, 73, 73, 87]
    var accessoryView:KeyboardAccessory!
    var datePicker           = UIDatePicker()
    let genderPicker         = UIPickerView()
    let locationManager      = LocationManager()
    var genderDatasource     = ["selectGender", "male", "female", "unisex"]
    var mobileNumber:String?
    var shouldVerifyOTP      = true
    
    enum ProfileSection:Int {
        case userImage
        case mobile
        case textField
        case actionButton
    }
    
    enum TextFieldRow:Int {
        case name
        case gender
        case dob
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
        if(user.userId == nil) {
            // Fetch user location only user is coming from Sign Up
            currentLocation()
        }
        
        // Store mobile number to compare if it was changed
        mobileNumber = user.cellNumber
    
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        picker = CountryPicker()
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)        //optional for UIPickerView theme changes
        picker.theme = theme //optional for UIPickerView theme changes
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
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
        
        // Determine if this screen has openened to view/edit/complete profile
        if user.userId != nil {
            isEditingProfile        = false
            editButton.isHidden     = false
            backButton.isSelected   = true
            backButton.setImage(#imageLiteral(resourceName: "red_cancel"), for: .normal)
        }
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
        
        func setError(rowIndex: Int, section: Int, message: String) {
            let indexPath = IndexPath.init(row: rowIndex, section: section)
            profileTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
                setError(rowIndex: 0, section:ProfileSection.mobile.rawValue, message: NSLocalizedString("invalidMobile", comment: ""))
                return false
            }
        }
        
        // 2. DOB Validation
        
        if let dob = user.dob, !dob.isEmpty {
            if !dob.isValidDob() {
                // Set error message
                setError(rowIndex: TextFieldRow.dob.rawValue, section:ProfileSection.textField.rawValue, message: NSLocalizedString("underage", comment: ""))
                return false
            }
        }
        
        // 3. Name Validation
        
        if user.userId != nil, user.name.isEmpty {
            // Set error message
            setError(rowIndex: TextFieldRow.name.rawValue, section:ProfileSection.textField.rawValue, message: NSLocalizedString("nameMissing", comment: ""))
            return false
        }
        
        return true
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: UIButton) {
        guard  !activityIndicator.isAnimating else {
            return
        }
        if sender.isSelected {
            dismiss(animated: true) {
                
            }
        }
        else {
            navigationController?.popViewController(animated: true)
        }
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
        guard  !activityIndicator.isAnimating, isEditingProfile  else {
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
    
    @IBAction func editOrSaveProfile(_ sender: UIButton) {
        // Update user profile
        if sender.isSelected {
            // Validate and save
            let status = isValid()
            if status {
                var parameters = user.updateParameter()
                if let prevMobileNumber = mobileNumber, let currentMobileNumber = user.cellNumber, prevMobileNumber == currentMobileNumber {
                    // Mobile number was not chagned so we'll remove this key to avoid OTP validation
                    parameters.removeValue(forKey: UserKey.mobile)
                    shouldVerifyOTP = false
                }
                requestUpdateUserProfile(withParameters: parameters, for: user.userId)
            }
        }
        else {
            // Enable editing mode
            sender.setTitle(sender.title(for: .selected), for: .normal)
            sender.isSelected = true
            isEditingProfile  = true
            currentLocation()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    private func gotoNextScreen(forUser user: User) {
        // Move to next screen after Sign Up
        if let chooseInterestViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.interest) as? ChooseInterestViewController {
            chooseInterestViewController.user = user
            navigationController?.pushViewController(chooseInterestViewController, animated: true)
        }
    }
}

extension ProfileViewController: KeyboardAccessoryDelegate, CountryPickerDelegate {
    
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
        var nextCellTag:Int!
        if let cell = self.editingTextField.superview?.superview, cell.tag == ProfileSection.mobile.rawValue {
            if user.userId != nil {
                nextCellTag = TextFieldRow.name.rawValue
            }
            else {
                nextCellTag = TextFieldRow.gender.rawValue
            }
        }
        else {
            nextCellTag = self.editingTextField.tag + 1
        }
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
        if self.editingTextField.tag == TextFieldRow.name.rawValue, let cell = self.editingTextField.superview?.superview as? ProfileTextFieldTableViewCell,
            cell.tag == ProfileSection.textField.rawValue {
            let indexPath = IndexPath.init(row: 0, section: ProfileSection.mobile.rawValue)
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
    
    // MARK: - Country picker delegate
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        if let editingTextField = self.editingTextField as? SkyFloatingLabelTextFieldWithIcon {
            editingTextField.text = phoneCode
            editingTextField.iconType = .image
            editingTextField.iconImage = flag
        }
        user.countryCode = phoneCode
        user.countryFlag = flag
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
        return !activityIndicator.isAnimating && isEditingProfile
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
        guard let section = sender.superview?.superview?.tag else {
            return
        }
        if section == ProfileSection.mobile.rawValue  {
            user.cellNumber = trimmedText?.replacingOccurrences(of: " ", with: "")
        }
        else if let textFieldRow = TextFieldRow(rawValue: sender.tag) {
            switch textFieldRow {
            case .name:
                user.name = sender.text
            case .gender:
                user.gender = sender.text
            case .dob:
                user.dob = sender.text
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

extension ProfileViewController: OTPBoxDelegate {
    
    // MARK: OTP Verification
    
    func validateOTP() {
        let otpBox = OTPBox.init(frame: self.view.frame)
        otpBox.delegate = self
        otpBox.user     = user
        otpBox.present(on: self.view)
    }
    
    // MARK: OTP Delgate
    
    func didDismiss(otpbox: OTPBox) {
        gotoNextScreen(forUser: user)
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
        return user.userId == nil ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ProfileSection.textField.rawValue && indexPath.row == TextFieldRow.name.rawValue && user.userId == nil {
            // If coming from Sign Up then Name field won't be visible
            return 0
        }
        return rowHeights[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell!
        let section = ProfileSection(rawValue: indexPath.section)!
        switch section {
        case .userImage:
            // For user images
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.profileImageViewCell, for: indexPath)
            let userImageViewCell = tableViewCell as! ProfileUserImageTableViewCell
            if let imageURL = user.imageURL {
                // Set user image if available
                userImageViewCell.userImageView.setImage(withURL: imageURL, placeholder: #imageLiteral(resourceName: "profile_photo"))
            }
            if tableViewCell.tag == 0 {
                tableViewCell.tag = 1 // Tag is set so that we don't add gesture every time
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(changeImage(_:)))
                userImageViewCell.addGestureRecognizer(tapGesture)
            }
            
        case .mobile:
            let mobileInputCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.mobileInputCell, for: indexPath) as! ProfileTextFieldTableViewCell
            mobileInputCell.countryCode.inputView = picker
            tableViewCell = mobileInputCell
            
            mobileInputCell.countryCode.iconType                = .image
            mobileInputCell.countryCode.text                    = user.countryCode
            mobileInputCell.countryCode.iconImage               = user.countryFlag
            mobileInputCell.inputTextField.text                 = user.cellNumber
            mobileInputCell.inputTextField.tag                  = indexPath.row
            mobileInputCell.inputTextField.inputAccessoryView   = accessoryView
            mobileInputCell.inputTextField.keyboardType         = .phonePad
            
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
                    case .name:
                        textFieldCell.inputTextField.returnKeyType   = .next
                        textFieldCell.inputTextField.text            = user.name
                        textFieldCell.inputTextField.textContentType = UITextContentType.name
                        textFieldCell.inputTextField.keyboardType    = .default
                    case .dob:
                        textFieldCell.inputTextField.inputView = datePicker
                        textFieldCell.inputTextField.text      = user.dob
                    case .gender:
                        textFieldCell.inputTextField.inputView = genderPicker
                        textFieldCell.inputTextField.text      = user.gender
                    case .address:
                        textFieldCell.inputTextField.returnKeyType   = .next
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
        tableViewCell.tag = indexPath.section
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
    
    private func requestUpdateUserProfile(withParameters parameters: Dictionary<String, Any>, for user:String) {
        // Create user account using filled details
        activityIndicator.startAnimating()
        weak var weakSelf = self
        oneMomentLabel.isHidden = false
        activityIndicator.startAnimating()
        let url = APIURL.url(apiEndPoint: APIEndPoint.updatUserProfile + user)
        webManager.httpRequest(method: .put, apiURL: url, body: parameters, completion: { (response) in
            // User account created
            weakSelf?.didUpdateProfile(withResponse: response)
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
                if let cellNumber =  user.cellNumber, !cellNumber.isEmpty {
                    // Validate OTP by user
                    validateOTP()
                }
                else {
                    // User han't provided Mobile Number
                    gotoNextScreen(forUser: user)
                }
                
            }
        }
        else if let errorMessage = response[APIKeys.errorMessage] as? String {
            // Show  error
            showAlert(withMessage: errorMessage)
        }
    }
    
    // MARK: - Request Completion
    
    private func didUpdateProfile(withResponse response: Dictionary<String, Any>) {
        activityIndicator.stopAnimating()
        oneMomentLabel.isHidden = true
        if let statusCode = response[APIKeys.status] as? String {
            if statusCode == HTTPStatus.success {
                user.update() // Save user details
                
                // Go to next screen
                if let cellNumber =  user.cellNumber, !cellNumber.isEmpty, shouldVerifyOTP {
                    // Validate OTP by user
                    validateOTP()
                }
                else {
                    // Mobile number won't be validated
                    dismiss(animated: true) {
                        
                    }
                }
                
            }
        }
        else if let errorMessage = response[APIKeys.errorMessage] as? String {
            // Show  error
            showAlert(withMessage: errorMessage)
        }
    }
}
