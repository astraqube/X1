//
//  Extesnion+String.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        // Validate email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // Validate password (At least 6 characters)
        return self.count >= 6
    }
    
    func isValidUsername() -> Bool {
        // Validate username (At least 6 characters)
        return self.count >= 6
    }
    
    func isOverFlowing() -> Bool {
        // Validate username and password (Up to 32 characters are allowed)
        return self.count > 32
    }
    
    func isValidName() -> Bool {
        // Validate fist name and last name (Up to 15 characters are allowed)
        return self.count < 15
    }
    
    func isValidDob(for minAge: Int = 13) -> Bool {
        // Default age is 13 years
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        if let dob = dateFormatter.date(from: self) {
            let difference = abs(dob.years(from: Date()))
            return difference >= minAge
        }
        return false
    }
    
    func isValidFullName() -> Bool {
        // Validate fist name and last name (Up to 15 characters are allowed)
        return self.count < 20
    }
    
    func isValidMobile() -> Bool {
        // Validate mobile number
        let mobile = self.replacingOccurrences(of: " ", with: "")
        let mobileRegex = "^[0-9]{10}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: mobile)
    }
    
    func dobDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.date(from: self)
    }
    
    func isoDate() -> Date? {
        let isoDateFormatter            = ISO8601DateFormatter.init()
        isoDateFormatter.timeZone       = TimeZone.current
        isoDateFormatter.formatOptions  = .withFullDate
        let date = isoDateFormatter.date(from: self)
        return date
    }
    
     func dateFromISOString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
    
    func boolean() -> Bool {
        return self == "1" ? true : false
    }
}
