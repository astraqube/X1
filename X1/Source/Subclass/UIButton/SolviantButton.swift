//
//  SolviantButton.swift
//  Solviant
//
//  Created by Rohit Kumar on 11/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class SolviantButton: UIButton {
    
    // MARK: - Intiliazer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeUI()
    }
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        backgroundColor                         = .red
        layer.borderWidth                       = 1.0
        layer.cornerRadius                      = 8
        layer.backgroundColor                   = UIColor.white.cgColor
        layer.sublayers?.last?.cornerRadius     = 8.0
        layer.sublayers?.last?.masksToBounds    = true
        layer.borderColor                       = UIColor.lightTheme().cgColor
        setTitleColor(UIColor.darkTheme(), for: .normal)
        darkShadow(withRadius: 5)
    }
    
    // MARK: - Hightlight Button
    
    @objc private func highlight(_ sender: UIButton) {
        layer.backgroundColor                   = UIColor.lightTheme().cgColor
        layer.borderColor                       = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
    }
    
    @objc private func fingerLifted(_ sender: UIButton) {
        layer.backgroundColor                   = UIColor.white.cgColor
        layer.borderColor                       = UIColor.lightTheme().cgColor
        setTitleColor(UIColor.darkTheme(), for: .normal)
    }
    
}
