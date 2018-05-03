//
//  Extension+Boolean.swift
//  Solviant
//
//  Created by Rohit Kumar on 03/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

extension Bool {
    func convertForWeb() -> Int {
        return self == true ? 1 : 0
    }
}
