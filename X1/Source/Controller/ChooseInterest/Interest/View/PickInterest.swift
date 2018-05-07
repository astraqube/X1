//
//  PickInterest.swift
//  Solviant
//
//  Created by Rohit Kumar on 07/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PickInterest: UIView {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var interestTableView: UITableView!
    
    // MARK: - Other Property
    
    var subcategories:[Category]?
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let interestView = Bundle.main.loadNibNamed("PickInterest", owner: self, options: [:])?.first as? UIView {
            interestView.frame = self.bounds
            self.addSubview(interestView)
            
            // Register cell
            registerCell(with: ReusableIdentifier.interestTableViewCell)
            
        }
    }
    
    // MARK: - Utility
    
    private func registerCell(with Identifer: String) {
        interestTableView.register(UINib.init(nibName: "InterestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: Identifer)
    }
    
    // MARK: - Datasource
    
    func setInterest(for subcategories: Category) {
        subcategories = subcategories.subcategories
        interestTableView.reloadData()
    }
}

extension PickInterest: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subcategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 1 row for each section to display interest
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Set header title
        if let subcategory = subcategories?[section] {
            return subcategory.name.capitalized
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tableViewCell = tableView.cellForRow(at: indexPath) as? InterestTableViewCell {
            return tableViewCell.interestCollectionView.contentSize.height
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.interestTableViewCell, for: indexPath) as! InterestTableViewCell
        // Configure cell
        return tableViewCell
    }
    
}
