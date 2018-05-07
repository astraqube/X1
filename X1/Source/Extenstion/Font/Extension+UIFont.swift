//
//  Extension+UIFont.swift
//  indeclap
//
//  Created by Huulke on 2/23/18.
//  Copyright © 2018 Huulke. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func robotoFont(wityType type: FontType, size: CGFloat) -> UIFont {
        // Return Raleway font with size and type
         // Raleway-Regular
        var fontName:String!
        switch type {
        case .semiBold:
            fontName = "Roboto-SemiBold"
        case .bold:
            fontName = "Roboto-Bold"
        case .italics:
            fontName = "Roboto-Italic"
        case .thin:
            fontName = "Roboto-Thin"
        case .light:
            fontName = "Roboto-Light"
        default:
            fontName = "Roboto-Regular"
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
    case thin
    case light
}

