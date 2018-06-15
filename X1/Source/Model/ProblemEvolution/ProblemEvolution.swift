//
//  ProblemEvolution.swift
//  Solviant
//
//  Created by Rohit Kumar on 15/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ProblemEvolution: NSObject {
    
    // MARK: - Property
    
    var principleName:String!
    var location:String?
    var dateTime:String!
    var categories:[String]?
    var statement:String!
    var redefinedStatements:[ProblemEvolution]?
    
    init?(with response: Dictionary<String, Any>) {
        // Initialize Model
        principleName = "Peter Parker"
        location      = "New Delhi"
        dateTime      = "5 mins ago"
        statement     = ""
        categories    = ["Swift", "iOS", "Android"]
    }
    
    static func model() -> [ProblemEvolution] {
        var problemEvolutions:[ProblemEvolution] = Array()
        if let problemEvolution = ProblemEvolution.init(with: [:]) {
            problemEvolutions.append(problemEvolution)
            problemEvolution.redefinedStatements = [problemEvolution, problemEvolution, problemEvolution, problemEvolution]
        }
        return problemEvolutions;
    }
}
