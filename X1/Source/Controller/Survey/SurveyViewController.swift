//
//  SurveyViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 18/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import fluid_slider

class SurveyViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet var ratingSliderCollection: [Slider]!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Custimize Slider
        for slider in ratingSliderCollection {
            setupRatingSlider(for: slider)
        }
    }
    
    private func setupRatingSlider(for slider: Slider) {
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 5) as NSNumber) ?? ""
            return NSAttributedString(string: string)
        }
        slider.setMinimumImage(#imageLiteral(resourceName: "sad"))
        slider.setMaximumImage(#imageLiteral(resourceName: "smile"))
        slider.imagesColor = UIColor.white
        slider.setMinimumLabelAttributedText(NSAttributedString.init(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]))
        slider.setMaximumLabelAttributedText(NSAttributedString.init(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor.orangeTheme()
        slider.valueViewColor = .white
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }

}
