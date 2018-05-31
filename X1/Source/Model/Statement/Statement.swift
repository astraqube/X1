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
    
/*
     {
     "__v" = 0;
     "_id" = 5b08521970b00c2991ba0cba;
     attachment = "";
     categoryes =             (
     Motherboard,
     Monitor,
     Cpu,
     "Expansion Cards",
     Java,
     Mysql,
     C
     );
     "created_at" = "2018-05-25T18:12:41.251Z";
     "expert_level" =             {
     "__v" = 0;
     "_id" = 5ac5cf495ccd5e249e939979;
     "created_at" = "2018-04-05T07:24:57.080Z";
     "is_active" = 1;
     "level_name" = professional;
     "modified_at" = "2018-04-05T07:24:57.080Z";
     };
     "is_active" = 1;
     "is_deleted" = 0;
     latitude = "28.55045431933381";
     longitude = "77.44059912696925";
     "modified_at" = "2018-05-25T18:12:41.251Z";
     principle =             {
     DOB = "5/11/88";
     "__v" = 0;
     "_id" = 5af59a9403c2a16e12079a47;
     address = "I-280 N";
     category =                 (
     );
     city = Hillsborough;
     country = "United States";
     "created_at" = "2018-05-11T13:28:52.769Z";
     email = "rohit@keychn.com";
     "full_name" = Rohit;
     gender = Male;
     headline = "";
     "image_url" = "";
     "is_active" = 1;
     "is_deleted" = 0;
     "last_company" = "";
     "linkedin_access" = 0;
     location =                 (
     "-122.35962046",
     "37.52830073"
     );
     "login_status" = 0;
     mobile = 8586954120;
     "modified_at" = "2018-05-11T13:28:52.769Z";
     password = "$2a$10$VQsSndmoKGjfVVBxIGa3Mejqi/HI.2NTXIelh5kTaOzLPLkiAgRIq";
     position = "";
     state = CA;
     title = "";
     token = "";
     "user_type" = 0;
     zipcode = 94010;
     };
     "statement_name" = Hey;
     "statement_response" =             (
     );
     "view_type" = global;
     }
 */
}
