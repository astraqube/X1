//
//  CardOverlayView.swift
//  Solviant
//
//  Created by Rohit Kumar on 28/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Koloda

class CardOverlayView: OverlayView {
    
    @IBOutlet weak var overlayImageView: UIImageView!
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = #imageLiteral(resourceName: "trash")
            case .right? :
                overlayImageView.image = #imageLiteral(resourceName: "save")
            case .down? :
                overlayImageView.image = #imageLiteral(resourceName: "report")
            default:
                overlayImageView.image = nil
            }
            
        }
    }
}
