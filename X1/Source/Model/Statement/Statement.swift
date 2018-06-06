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
    
    
    init?(with response: Dictionary<String, Any>) {
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

    }
}
