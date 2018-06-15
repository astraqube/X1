//
//  Statement.swift
//  Solviant
//
//  Created by Rohit Kumar on 25/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit



class Statement: NSObject {
    
    var identifier:String!
    var name:String!
    var city:String?
    var tags:[String]?
    var problemText:String!
    var time:Date?
    var userImageURL:String?
    var expertLevel = ExpertLevel.rookie
    
    
    init?(with response: Dictionary<String, Any>, isRedefined: Bool = false) {
        guard let id = response[PostStatementKey.identifier] as? String,
            let principal = response[PostStatementKey.principal] as? Dictionary<String, Any>,
            let principalName = principal[PostStatementKey.principalName] as? String,
        let text = response[PostStatementKey.statement] as? String else {
            return
        }
        
        identifier   = id
        name         = principalName
        problemText  = text
        tags         = response[PostStatementKey.tags] as? Array
        city = (principal[PostStatementKey.city] as? String) ?? "Nearby"
        if let dateTime = response[PostStatementKey.createdAt] as? String {
            time = dateTime.dateFromISOString()
        }
        if let expertLevelInfo = response[PostStatementKey.principalType] as? Dictionary<String, Any>, let expertType =  expertLevelInfo[PostStatementKey.expertType] as? String {
            expertLevel = ExpertLevel.expertLevel(by: expertType)
        }
        
        if isRedefined, let redefinedStatments = response[APIKeys.redefinedStatment] as? Array<Dictionary<String, Any>>,
            let redefinedStatment = redefinedStatments.last  {
            if let text = redefinedStatment[PostStatementKey.statement] as? String {
                problemText = text
            }
            tags       = redefinedStatment[PostStatementKey.tags] as? Array
            if let dateTime = response[PostStatementKey.createdAt] as? String {
                time = dateTime.dateFromISOString()
            }
        }
    }
    
    init?(my statements: Dictionary<String, Any>) {
        guard let id = statements[PostStatementKey.identifier] as? String,
            let text = statements[PostStatementKey.statement] as? String else {
                return
        }
        
        identifier   = id
        problemText  = text
        tags         = statements[PostStatementKey.tags] as? Array
        if let dateTime = statements[PostStatementKey.createdAt] as? String {
            time = dateTime.dateFromISOString()
        }
    }
}
