//
//  Extenstion+UIView.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

extension UIView {
    
    func darkShadow() {
        // Put dark shadow the the view
        layer.masksToBounds    = false
        layer.shadowOffset     = CGSize.zero
        layer.shadowRadius     = 1.5
        layer.shadowOpacity    = 1
        layer.shadowColor      = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    func darkShadow(withRadius radius:CGFloat) {
        // Put dark shadow the the view
        layer.masksToBounds    = false
        layer.shadowOffset     = CGSize.zero
        layer.shadowRadius     = radius
        layer.shadowOpacity    = 1
        layer.shadowColor      = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
}
