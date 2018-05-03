//
//  LinkedIn.swift
//  indeclap
//
//  Created by Huulke on 12/14/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

class LinkedIn: NSObject {
    
    func loginWithLinkedIn(completion:@escaping(_ liUser:LinkedInUser) -> Void) {
        LISDKSessionManager.createSession(withAuth: [LISDK_EMAILADDRESS_PERMISSION, LISDK_BASIC_PROFILE_PERMISSION], state: "variousstate", showGoToAppStoreDialog: true, successBlock: { (state) in
            // Autheticated successfully
            if LISDKSessionManager.hasValidSession() {
                let profileLinkURL = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-urls::(original),public-profile-url,headline)"
                LISDKAPIHelper.sharedInstance().getRequest(profileLinkURL, success: { (response) in
                    // Fetched user profile
                    if let userInfo = response?.data {
                        print("User LI Profile \(userInfo)")
                        if let data = userInfo.data(using: String.Encoding.utf8) {
                            let linkedInUser = LinkedInUser.init(withResponse: data)
                            DispatchQueue.main.async {
                                completion(linkedInUser)
                            }
                        }
                    }
                }, error: { (error) in
                    // Error in fetching user profile
                    print("Error in fetching LI Profile")
                })
            }
        }) { (error) in
            // Failed to Autheticate LI user
            print("Error in authetication \(error.debugDescription)")
        }
    }
}

struct LinkedInUser {
    var firstName:String?
    var lastName:String?
    var headline:String?
    var identifier:String?
    var profileURL:String?
    var email:String?
    var pictureURL:String?
    
    init(withResponse responseData: Data) {
        do {
            if let liUserInfo  =  try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any> {
                firstName      = liUserInfo[LinkedInKeys.firstName] as? String
                lastName       = liUserInfo[LinkedInKeys.lastName] as? String
                headline       = liUserInfo[LinkedInKeys.headline] as? String
                identifier     = liUserInfo[LinkedInKeys.identifier] as? String
                profileURL     = liUserInfo[LinkedInKeys.profileURL] as? String
                email          = liUserInfo[LinkedInKeys.emailId] as? String
                if let pictureURLInfo = liUserInfo[LinkedInKeys.pictureURL] as? Dictionary<String,Any> {
                    if let pictureURLs   = pictureURLInfo[LinkedInKeys.value] as? Array<String> {
                        pictureURL = pictureURLs.first
                    }
                }
            }
        }
        catch   {
            
        }
    }
    
    func parameteres() -> Dictionary<String,Any> {
        var parameters = Dictionary<String, Any>()
        if let value = email {
            parameters[LinkedInKeys.email] = value
        }
        
       /* if let value = firstName {
            parameters[LinkedInKeys.firstName] = value
        }
        if let value = lastName {
            parameters[LinkedInKeys.lastName] = value
        }
        
        if let value = profileURL {
            parameters[LinkedInKeys.liProfileUrl] = value
        }
        if let value = headline {
            parameters[LinkedInKeys.position] = value
        }
        if let value = identifier {
            parameters[LinkedInKeys.liIdentfier] = value
        }
        if let value = pictureURL {
            parameters[LinkedInKeys.imageURL] = value
        }
        if let token = DeviceIdentifier.apnsToken {
            parameters[UserKey.apnsToken] = token
        }
        if let deviceId =  DeviceIdentifier.deviceId {
            parameters[UserKey.deviceId] = deviceId
        } */
        return parameters
    }
}

struct LinkedInKeys {
    static let firstName    = "firstName"
    static let lastName     = "lastName"
    static let headline     = "headline"
    static let email        = "email"
    static let emailId      = "emailAddress"
    static let profileURL   = "publicProfileUrl"
    static let liProfileUrl = "linkedinProfileUrl"
    static let imageURL     = "picture"
    static let identifier   = "id"
    static let pictureURL   = "pictureUrls"
    static let value        = "values"
    static let position     = "position"
    static let signupMode   = "signupMode"
    static let liIdentfier  = "linkedinId"
}
