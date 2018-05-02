//
//  Extension+UIFont.swift
//  indeclap
//
//  Created by Huulke on 2/23/18.
//  Copyright © 2018 Huulke. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func ralewayFont(wityType type: FontType, size: CGFloat) -> UIFont {
        // Return Raleway font with size and type
         // Raleway-Regular
        var fontName:String!
        switch type {
        case .semiBold:
            fontName = "Raleway-SemiBold"
        case .bold:
            fontName = "Raleway-Bold"
        case .italics:
            fontName = "Raleway-Italic"
        default:
            fontName = "Raleway-Regular"
        }
        if let font =  UIFont.init(name: fontName, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

enum FontType {
    case regular
    case semiBold
    case bold
    case italics
}

