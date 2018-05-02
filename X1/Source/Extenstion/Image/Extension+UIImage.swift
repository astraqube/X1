//
//  Extension+UIImage.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInKB:Int) -> Data? {
        let sizeInBytes = expectedSizeInKB * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            return data
        }
        return nil
    }
    
}
