//
//  Extension+UICollectionView.swift
//  Solviant
//
//  Created by Rohit Kumar on 07/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}
