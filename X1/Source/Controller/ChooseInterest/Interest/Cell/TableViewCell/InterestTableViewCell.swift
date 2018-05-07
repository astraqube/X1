//
//  InterestTableViewCell.swift
//  Solviant
//
//  Created by Rohit Kumar on 07/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class InterestTableViewCell: UITableViewCell {

    // MARK:- IB Outlet
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    // MARK:- Other Property
    let cellPading:CGFloat = 5.0
    let cellHeight:CGFloat = 21.0
    
    var datasource:[Category]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Register cell for embeded CollectionView
        registerCell(with: ReusableIdentifier.interestCollectionViewCell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Utility
    
    private func registerCell(with identifier: String) {
        // Register collection view cell
        interestCollectionView.register(UINib.init(nibName: "InterestCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
    }
}

extension InterestTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- CollectionView Datasource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let interest = datasource?[indexPath.row] {
            return CGSize.init(width: interest.cellWidth + cellPading, height: cellHeight)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let interestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.interestCollectionViewCell, for: indexPath) as! InterestCollectionViewCell
        return interestCollectionViewCell
    }
    
}
