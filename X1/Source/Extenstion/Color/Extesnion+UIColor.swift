//
//  Extesnion+UIColor.swift
//  X1
//
//  Created by Rohit Kumar on 16/04/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func theme() -> UIColor {
        // 34, 105, 212
        return UIColor.init(red: 0.13, green: 0.41, blue: 0.83, alpha: 1.0)
    }
    
    static func lightTheme() -> UIColor {
        // 67,160,192
        return UIColor.init(red: 0.26, green: 0.62, blue: 0.75, alpha: 1.0)
    }
    
    static func darkTheme() -> UIColor {
        // 29,103,143 // #1d678f
        return UIColor.init(red: 0.11, green: 0.4, blue: 0.56, alpha: 1.0)
    }
}
