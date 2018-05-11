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

// MARK: - Struct Constant

struct StoryboardIdentifier {
    static let home       = "HomeViewController"
    static let landing    = "LandingViewController"
    static let profile    = "ProfileViewController"
    static let interest   = "ChooseInterestViewController"
    static let selectRole = "SelectRoleViewController"
    static let signUp     = "SignUpViewController"
    static let tags       = "TagPopOverTableViewController"
    static let tabBar     = "HomeTabBarViewController"
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
}

struct APIKeys {
    static let statusCode   = "statusCode"
    static let status       = "status"
    static let errorMessage = "message"
    static let result       = "result"
    static let userInfo     = "userInfo"
    static let categoryName = "category_name"
    static let identifier   = "_id"
    static let imageURL     = "image_url"
}

struct DeviceIdentifier {
    static var deviceId:String?
    static var apnsToken:String?
}


struct APIEndPoint {
    static let signIn        = "login"
    static let signUp        = "register"
    static let linkedInLogin = "login/linkedin"
    static let category      = "category/levelone"
    static let subcategory   = "category/leveltwo/"
    static let intersts      = "category/levelthree/"
}

struct APIURL {
    static let baseURL = "http://35.171.22.162:9004/api/v1/"
    
    static func url(apiEndPoint endPoint: String) -> String {
        let apiURL = baseURL + endPoint
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
    static let latitude         = "latitude"
    static let longitude        = "longitude"
    static let deviceId         = "deviceId"
    static let userType         = "user_type"
    static let accessToken      = "id_token"
    static let apnsToken        = "apns_token"
    static let imageURL         = "image_url"
    static let location         = "location"
    static let linkedInAccess   = "linkedin_access"
}

struct HTTPStatus {
    static let ok = 200
    static let validationError = 400
    static let unreachable     = 404
    static let success         = "success"
}


