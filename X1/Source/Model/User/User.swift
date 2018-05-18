//
//  User.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject {
    
    // MARK: Property
    
    var userId:String!
    var name:String!
    var password:String?
    var email:String!
    var cellNumber:String?
    var dob:String?
    var gender:String?
    var imageURL:String?
    var selectedImage:UIImage?
    var accessToken:String?
    var addressLine:String?
    var city:String?
    var state:String?
    var country:String?
    var zipCode:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var type:UserType!
    var isLinkedInEnabled = false
    
    
    // MARK: Initializers
    
    init?(response: Dictionary<String,Any>) {
        // Intialize User Model
        guard let userId = response[UserKey.userId] as? String,
            let name         = response[UserKey.name] as? String,
            let email        = response[UserKey.email] as? String else {
                return nil
        }
        self.userId = userId
        self.name   = name
        self.password = response[UserKey.password] as? String
        self.email    = email
        cellNumber = response[UserKey.mobile] as? String
        dob        = response[UserKey.dob] as? String
        gender     = response[UserKey.gender] as? String
        imageURL   = response[UserKey.imageURL] as? String
        accessToken = response[UserKey.accessToken] as? String
        addressLine = response[UserKey.address] as? String
        city        = response[UserKey.city] as? String
        state       = response[UserKey.state] as? String
        country     = response[UserKey.country] as? String
        zipCode     = response[UserKey.zipcode] as? String
        if let location = response[UserKey.location] as? Array<CLLocationDegrees> {
            latitude    = location.last
            longitude   = location.first
        }
        else {
            latitude    = response[UserKey.latitude] as? CLLocationDegrees
            longitude   = response[UserKey.latitude] as? CLLocationDegrees
        }
        if let userType = response[UserKey.userType] as? Int {
            type = UserType(rawValue: userType)
        }
        else if let value = response[UserKey.userType] as? String, let userType = Int(value) {
            type = UserType(rawValue: userType)
        }
    }
    
    init?(withLinkedIn user: LinkedInUser) {
        guard let emailId = user.email,
            let fullName = user.firstName else {
            return nil
        }
        email               = emailId
        name                = fullName + (user.lastName ?? "")
        imageURL            = user.pictureURL
        isLinkedInEnabled   = true
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Local Database Operation
    
    func save() {
        // Create user in local database
        
        let dbManager   = DBOperation()
        // Check if user data is already there then update values
        let checkQuery  = "SELECT id from user WHERE _id = '\(userId!)'"
        let resultArray = dbManager.fetchDataForQuery(query: checkQuery);
        if resultArray.count > 0 {
            // Update user data
            update()
            return
        }
    
        let insertQuery = "INSERT INTO user (_id, full_name, email, password, user_type, image_url, id_token, address, city, state, country, zip, latitude, longitude, mobile, dob, gender) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        let valuesArray:[Any] = [userId as Any, name as Any, email as Any, password as Any, type.rawValue as Any, imageURL as Any, accessToken as Any, addressLine as Any, city as Any, state as Any, country as Any, zipCode as Any, latitude as Any, longitude as Any, cellNumber as Any, dob as Any, gender as Any]
        dbManager.executeInsertUpdate(query: insertQuery, columnValues: valuesArray)
    }
    
    func update() {
        // Update user
        let dbManager   = DBOperation()
        
        let updateQuery = "UPDATE user SET (full_name = ?, password = ?, user_type = ?, image_url = ?, id_token = ?, address = ?, city = ?, state = ?, country = ?, zip = ?, latitude = ?, longitude = ?, mobile = ?, dob = ?, gender = ?) WHERE _id = ?"
        let valuesArray:[Any] = [name as Any, password as Any, type.rawValue as Any, imageURL as Any, accessToken as Any, addressLine as Any, city as Any, state as Any, country as Any, zipCode as Any, latitude as Any, longitude as Any, cellNumber as Any, dob as Any, gender as Any, userId as Any]
        dbManager.executeInsertUpdate(query: updateQuery, columnValues: valuesArray)
    }
    
    func delete() {
        // Delete user from local database
        let dbManager   = DBOperation()
        let deleteQuery = "DELETE FROM user WHERE _id = ?"
        let valuesArray:[Any] = [userId as Any]
        dbManager.executeInsertUpdate(query: deleteQuery, columnValues: valuesArray)
    }
    
    static func loggedInUser() -> User? {
        let dbManager   = DBOperation()
        let fetchQuery  = "SELECT * FROM user ORDER BY id DESC LIMIT 1"
        let resultArray = dbManager.fetchDataForQuery(query: fetchQuery)
        if resultArray.count > 0 {
            if let userInfo = resultArray.first {
                let user     = User.init(response: userInfo) // Logged in user details
                return user
            }
        }
        return nil // If there is no logged in user
    }
    
    // MARK: - Web Parameters
    
    func loginParameters() -> Dictionary<String, Any> {
        var parameters:[String: Any] = Dictionary()
        parameters[UserKey.email]       = email
        parameters[UserKey.password]    = password
        return parameters
    }
    
     func parameter() -> Dictionary<String, Any> {
        // Add parameters
        var parameters:[String: Any] = Dictionary()
        parameters[UserKey.name]            = name
        parameters[UserKey.email]           = email
        parameters[UserKey.password]        = password
        parameters[UserKey.userType]        = type.rawValue
        parameters[UserKey.linkedInAccess]  = isLinkedInEnabled.convertForWeb()
        if let mobile = cellNumber {
            parameters[UserKey.mobile]      = mobile
        }
        if let imageURL = imageURL {
            parameters[UserKey.imageURL]    = imageURL
        }
        if let dob = dob {
            parameters[UserKey.dob]         = dob
        }
        if let gender = gender {
            parameters[UserKey.gender]      = gender
        }
        if let addressLine = addressLine {
            parameters[UserKey.address]     = addressLine
        }
        if let city = city {
            parameters[UserKey.city]        = city
        }
        if let state = state {
            parameters[UserKey.state]       = state
        }
        if let country = country {
            parameters[UserKey.country]     = country
        }
        if let zipCode = zipCode {
            parameters[UserKey.zipcode]     = zipCode
        }
        if let latitude = latitude {
            parameters[UserKey.latitude]    = latitude
        }
        if let longitude = longitude {
            parameters[UserKey.longitude]   = longitude
        }
        parameters[UserKey.countryCode]   = "91"
        parameters["mobile"]   = "8586954120"
        return parameters
    }
}


