//
//  Constant.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

// MARK: - Enums

enum ResponseType {
    case server
    case local
}

enum UserType:Int {
    case principal
    case resource
    case both
}

enum TabBarIndex: Int {
    case interest
    case survey
    case home
    case statement
    case meeting
}

enum SwipeActionDirection: Int {
    case left
    case down
    case right
    case none
}

enum ExpertLevel: Int {
    case rookie
    case experienced
    case professional
    case expert
    case solvinat
    
    static func expertLevel(by name:String) -> ExpertLevel {
        switch name {
        case "rookie":
           return ExpertLevel.rookie
        case "experienced":
            return ExpertLevel.experienced
        case "professional":
            return ExpertLevel.professional
        case "expert":
            return ExpertLevel.expert
        case "solviant":
            return ExpertLevel.solvinat
        default:
            return ExpertLevel.rookie
        }
    }
    
    func description () -> (String, String) {
        switch self {
        case .rookie:
            return ("Rookie", "1 year of experience.")
        case .experienced:
            return ("Experienced", "3 years of experience.")
        case .professional:
            return ("Professional", "3-5 years of experience.")
        case .expert:
            return ("Expert", "More than 5 years experience with certification from other experts.")
        case .solvinat:
            return ("Solviant", "Champion for Soviant app.")
        }
    }
    
    func identifier () -> (String) {
        switch self {
        case .rookie:
            return "5ac5cf335ccd5e249e939977"
        case .experienced:
            return "5ac5cf425ccd5e249e939978"
        case .professional:
            return "5ac5cf495ccd5e249e939979"
        case .expert:
            return "5ac5cf4e5ccd5e249e93997a"
        case .solvinat:
            return "5ac5cf545ccd5e249e93997b"
        }
    }
}

enum PostUrgency: Int {
    case urgent
    case high
    case medium
    case low
    
    func description () -> (String, String) {
        switch self {
        case .urgent:
            return ("Urgent", "Valid for 2 hours")
        case .high:
            return ("High", "Valid for 1 day")
        case .medium:
            return ("Medium", "Valid fof 1 week")
        case .low:
            return ("Low", "Valid for 3 weeks")
        }
    }
    
    func expirationInterval() -> TimeInterval {
        var validInterval:TimeInterval! // In seconds
        switch self {
        case .urgent:
            validInterval = 3600
        case .high:
            validInterval = 86400 // Seconds in one day
        case .medium:
            validInterval = 604800 // Seconds in one week
        case .low:
            validInterval = 1814400 // Seconds in 3 weeks
        }
        let expirationTime = (NSDate().timeIntervalSince1970 + validInterval) * 1000 // Converted to milliseconds
        return expirationTime
    }
}

// MARK: - Struct Constant

struct StoryboardIdentifier {
    static let home              = "HomeViewController"
    static let landing           = "LandingViewController"
    static let profile           = "ProfileViewController"
    static let interest          = "ChooseInterestViewController"
    static let selectRole        = "SelectRoleViewController"
    static let signUp            = "SignUpViewController"
    static let tags              = "TagPopOverTableViewController"
    static let tabBar            = "HomeTabBarViewController"
    static let letsBegin         = "LetsBeginViewController"
    static let rateInterest      = "RateInterestViewController"
}

struct ReusableIdentifier {
    static let profileImageViewCell         = "ProfileUserImageTableViewCell"
    static let profileTextFieldCell         = "ProfileTextFieldTableViewCell"
    static let profileDoneButtonCell        = "ProfileDoneButtonTableViewCell"
    static let selectCategoryCell           = "InterestCategoryCollectionViewCell"
    static let subcategoryCell              = "SubcategoryCollectionViewCell"
    static let interestTableViewCell        = "InterestCollectionViewCell"
    static let interestCollectionViewCell   = "InterestTableViewCell"
    static let tagsTableViewCell            = "TagsTableViewCell"
    static let questionCollectionViewCell   = "QuestionCollectionViewCell"
    static let ratingOverviewCell           = "RatingOverviewTableViewCell"
    static let postUrgencyCell              = "PostUrgencyTableViewCell"
    static let mobileInputCell              = "MobileNumberInput"
    static let addResponseTableCell         = "AddResponseTableViewCell"
    static let popUpTableCell               = "PopUpCell"
    static let timerTableCell               = "TimerTableCell"
    static let selectImageCollectionCell    = "ImageSelectionCollectionViewCell"
    static let principalPopupTableCell    = "PrincipalPopupTableCell"
    static let availabilityCollectionCell    = "AvailabilityCollectionCell"

}

struct APIKeys {
    static let statusCode           = "statusCode"
    static let status               = "status"
    static let errorMessage         = "message"
    static let result               = "result"
    static let userInfo             = "userInfo"
    static let categoryName         = "category_name"
    static let identifier           = "_id"
    static let superIdentifier      = "categorieleveltwo"
    static let imageURL             = "image_url"
    static let isMobileVerified     = "verify_mobile"
    static let resource             = "resource"
}

struct PostStatementKey {
    static let statement      = "statement_name"
    static let principle      = "principle"
    static let category       = "category"
    static let expertLevel    = "expert_level"
    static let priority       = "priority"
    static let latitude       = "latitude"
    static let longitude      = "longitude"
    static let location       = "location"
    static let global         = "global"
    static let expertType     = "level_name"
    static let createdAt      = "created_at"
    static let principalName  = "full_name"
    static let resourceName   = "full_name"
    static let tags           = "categoryes"
    static let city           = "city"
    static let principal      = "principle"
    static let principalType  = "expert_level"
    static let identifier     = "_id"
    static let statementId    = "id"
    static let resourceId     = "r_id"
    static let response       = "response_statement"
    
}

struct DeviceIdentifier {
    static var deviceId:String?
    static var apnsToken:String?
}


struct APIEndPoint {
    static let signIn               = "login"
    static let signUp               = "register"
    static let linkedInLogin        = "login/linkedin"
    static let category             = "category/levelone"
    static let subcategory          = "category/leveltwo/"
    static let intersts             = "category/levelthree/"
    static let fetchPosts           = "statements"
    static let verifyOTP            = "mobile/verification"
    static let resendOTP            = "resend"
    static let createPost           = "statement"
    static let recordSwipe          = "assign/statement/"
    static let responseSwipe        = "assign/response/"
    static let resourceStatements   = "statements/resource/"
    
    static func submitResponse(with resourceId: String, statementId: String) -> String {
        let addResponse = "response/resource/" + resourceId + "/statement/" + statementId
        return addResponse
    }
    
    static func statement(with principalId: String) -> String {
        let createStatement = "principal/" + principalId  + "/statement"
        return createStatement
    }
    
    static func fetchResponse(with principalId : String, statementId: String) -> String {
        let fetchResponse = "response/principal/" + principalId + "/statement/" + statementId
        return fetchResponse
    }
}

struct APIURL {
    static let baseURL      = "http://35.171.22.162:9004/api/v1/"
    static let statementURL = "http://35.171.22.162:9002/api/v1/"
    
    static func url(apiEndPoint endPoint: String) -> String {
        let apiURL = baseURL + endPoint
        return apiURL
    }
    
    static func statementUrl(apiEndPoint endPoint: String) -> String {
        let apiURL = statementURL + endPoint
        return apiURL
    }
}

struct UserKey {
    static let name             = "full_name"
    static let email            = "email"
    static let password         = "password"
    static let userId           = "_id"
    static let mobile           = "mobile"
    static let gender           = "gender"
    static let dob              = "DOB"
    static let zipcode          = "zipcode"
    static let city             = "city"
    static let state            = "state"
    static let address          = "address"
    static let country          = "country"
    static let countryCode      = "country_code"
    static let latitude         = "latitude"
    static let longitude        = "longitude"
    static let deviceId         = "deviceId"
    static let userType         = "user_type"
    static let accessToken      = "id_token"
    static let apnsToken        = "apns_token"
    static let imageURL         = "image_url"
    static let location         = "location"
    static let linkedInAccess   = "linkedin_access"
    static let phoneNumber      = "phone_number"
    static let otpCode          = "verification_code"
    static let userIdentifier   = "user_id"
}

struct HTTPStatus {
    static let ok = 200
    static let validationError = 400
    static let unreachable     = 404
    static let success         = "success"
}


