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
    let webManager = WebRequestManager()
    
    // MARK: - Other Property
    weak var delegate:InterestSelectionDelegate?
    
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
        interestTableView.estimatedRowHeight = 80
        interestTableView.rowHeight          = UITableViewAutomaticDimension
    }
    
    // MARK: - Datasource
    
    func setInterest(for subcategories: [Category]) {
        self.subcategories = subcategories
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.interestTableViewCell, for: indexPath) as! InterestTableViewCell
        // Configure cell
        tableViewCell.delegate = self
        tableViewCell.tag = indexPath.section
        if let interests = subcategories?[indexPath.section].subcategories {
            tableViewCell.activityIndicator.stopAnimating()
            // Reload interests
            tableViewCell.setInterest(for: interests)
        }
        else if let subcategory = subcategories?[indexPath.section] {
            tableViewCell.activityIndicator.startAnimating()
            tableViewCell.datasource = nil
            tableViewCell.removeInterest()
            requestFetchInterst(for: subcategory)
        }
        
        return tableViewCell
    }
    
}

extension PickInterest: TagSelectionDelegate {
    
    func didTap(_ tableCell: UITableViewCell, at index: Int, selected: Bool) {
        // Tag Seleccted
        if let delegate = delegate, let subcategory = subcategories?[tableCell.tag], let tag = subcategory.subcategories?[index] {
            delegate.didSelect(in: subcategory, for: tag, selected: selected)
        }
    }
}

extension PickInterest  {
    
    // MARK: - Network Request
    
    private func requestFetchInterst(for subcategory: Category) {
        // Network request to fetch interests (3rd level)
        let apiURL = APIURL.url(apiEndPoint: APIEndPoint.intersts) + subcategory.identifier
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            // Category fetched
            weakSelf?.didFetchInterests(with: response, for: subcategory)
        }) { (error) in
            // Error in fetching interests (Do nothing)
        }
    }
    
    private func didFetchInterests(with response: Dictionary<String, Any>, for subcategory: Category) {
        // Intialize model from response
        if let subcategories = response[APIKeys.result] as? Array<Dictionary<String, Any>> {
            subcategory.subcategories = Array()
            subcategory.tags = Array()
            for categoryInfo in subcategories {
                if let category = Category.init(with: categoryInfo) {
                    subcategory.subcategories?.append(category)
                    subcategory.tags?.append(category.name.capitalized)
                }
            }
        }
        
        if let subcategories = subcategories, subcategories.contains(subcategory) {
            // Reload tableview data
            interestTableView.reloadData()
        }
    }
}

protocol InterestSelectionDelegate:class {
    // To forward tag selection to parent classes
    func didSelect(in subcategory:Category, for tag: Category, selected: Bool)
}


