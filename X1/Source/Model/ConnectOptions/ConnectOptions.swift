//
//  ConnectOptions.swift
//  Solviant
//
//  Created by Sushil Mishra on 08/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import Foundation

class ConnectOptions {
    var name: String;
    var isSelected: Bool;
    
    init(name: String, selected: Bool = false) {
        self.name = name
        self.isSelected = selected
    }
}
