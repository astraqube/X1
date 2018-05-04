//
//  Category.swift
//  Solviant
//
//  Created by Rohit Kumar on 04/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var identifier:String!
    var name:String!
    var imageURL:String?
    var subcategories:[Category]?
    var isSelected = false
    
    init?(with response: Dictionary<String, Any>) {
        guard let id = response[APIKeys.identifier] as? String,
        let categoryName     = response[APIKeys.categoryName] as? String
        else {
            return nil
        }
        identifier      = id
        name            = categoryName
        imageURL        = response[APIKeys.imageURL] as? String
    }

}
