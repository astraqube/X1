
//
//  ChooseInterestViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 03/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class ChooseInterestViewController: UIViewController {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var carouselFlowLayout: UPCarouselFlowLayout!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK: - Other Property
    
    var itemSize:CGSize!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize UI
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Do any additional setup after loading the view.
        carouselFlowLayout.scrollDirection = .horizontal
        var size    = categoryCollectionView.frame.size
        size.width  = 160
        size.height -= 5
        carouselFlowLayout.itemSize = size
        carouselFlowLayout.spacingMode = .fixed(spacing: 10)
    }
    
    // MARK: - IB Action

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
}

extension ChooseInterestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.selecteCategory, for: indexPath) as! InterestCategoryCollectionViewCell
        return categoryCell
    }
}
