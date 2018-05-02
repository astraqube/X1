//
//  Extension+UIImageView.swift
//  indeclap
//
//  Created by Huulke on 2/26/18.
//  Copyright © 2018 Huulke. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func setImage(withURL url:String, placeholder: UIImage?) {
        guard let imageURL = URL.init(string: url) else {
            return
        }
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
        self.sd_setImage(with: imageURL, placeholderImage: placeholder)
    }
}
