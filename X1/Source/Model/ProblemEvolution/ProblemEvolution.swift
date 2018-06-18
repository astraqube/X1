//
//  ProblemEvolution.swift
//  Solviant
//
//  Created by Rohit Kumar on 15/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ProblemEvolution: Statement {
    
    // MARK: - Property
    
    var redefinedStatements:[RedefinedStatement]?
    
    class RedefinedStatement: NSObject {
        var statement:String!
        var dateTime:Date?
        var categories:[String]?
        
        override init() {
            super.init()
        }
        
        init?(with response: Dictionary<String, Any>) {
            // Redefined statements
            guard let redefinedStatment = response[PostStatementKey.statement] as? String,
            let createdDate             = (response[PostStatementKey.createdAt] as? String)?.dateFromISOString() else {
                return nil
            }
            statement   = redefinedStatment
            dateTime    = createdDate
            categories  = response[PostStatementKey.tags] as? Array<String>
        }
    }
    
    init?(with response: Dictionary<String, Any>) {
        // Original Problem Statements
        super.init(with: response, isRedefined: false)
        redefinedStatements = Array()
        
        if let redefinedStatmentsInfo = response[APIKeys.redefinedStatment] as? Array<Dictionary<String, Any>> {
            // Parse all redefined statements
            let repostedStatements = redefinedStatmentsInfo.filter {$0[PostStatementKey.isReposted] as? Bool == true}
            for redefinedStatmentInfo in repostedStatements {
                // Create models
                if let redefinedStatement = RedefinedStatement.init(with: redefinedStatmentInfo) {
                    redefinedStatements?.append(redefinedStatement)
                }
            }
        }
        
        // Add the orignal problem statement as redefined one to appear in same tableView
        let originalStatment        = RedefinedStatement()
        originalStatment.statement  = problemText
        originalStatment.dateTime   = time
        originalStatment.categories = tags
        
        if redefinedStatements!.count > 0 {
            // Insert the last redefiend statemetn to be shown on the top
            let lastEditedStatement = redefinedStatements!.last!
           redefinedStatements?.insert(lastEditedStatement, at: 0)
           redefinedStatements?.insert(originalStatment, at: 1)
        }
        else {
            redefinedStatements?.append(originalStatment)
        }
    }
}
