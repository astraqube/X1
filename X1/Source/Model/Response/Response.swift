//
//  Response.swift
//  Solviant
//
//  Created by Rohit Kumar on 08/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit


class Response: NSObject {
   
    var identifier:String!
    var resourceName:String!
    var city:String!
    var expertLevel = ExpertLevel.rookie
    var time:Date?
    var question:String!
    
     init?(with response: Dictionary<String, Any>) {
        guard let question      = response[PostStatementKey.response] as? String,
              let identifier    = response[PostStatementKey.identifier] as? String,
              let resourceInfo  = response[APIKeys.resource] as? Dictionary<String, Any>,
              let resourceName  = resourceInfo[PostStatementKey.resourceName] as? String else {
            return
        }
        
        self.resourceName   = resourceName
        self.identifier     = identifier
        self.question       = question
        city = (resourceInfo[PostStatementKey.city] as? String) ?? "Nearby"
        if let dateTime = response[PostStatementKey.createdAt] as? String {
            time = dateTime.dateFromISOString()
        }
        if let expertLevelInfo = response[PostStatementKey.principalType] as? Dictionary<String, Any>, let expertType =  expertLevelInfo[PostStatementKey.expertType] as? String {
            expertLevel = ExpertLevel.expertLevel(by: expertType)
        }
    }
    
}
