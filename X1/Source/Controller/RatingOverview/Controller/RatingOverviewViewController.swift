//
//  RatingOverviewViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 18/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class RatingOverviewViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var ratingOverviewTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Other Property
    
    var draggedCategories:Dictionary<ExpertLevel, [Category]>!
    var allKeys:Array<ExpertLevel>?
    var user:User!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        allKeys = Array(draggedCategories.keys)
        allKeys = allKeys?.sorted {
            return $0.rawValue < $1.rawValue
        }
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    
    @IBAction func submitRating(_ sender: Any) {
        // Save ratings
        guard !activityIndicator.isAnimating else {
            return
        }
        activityIndicator.startAnimating()
        perform(#selector(gotToLetsBeginScreen), with: nil, afterDelay: 3)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Customize button as per them appearnace
        submitButton.backgroundColor = .clear
        submitButton.darkShadow(withRadius: 5)
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.backgroundColor = UIColor.white.cgColor
        submitButton.layer.cornerRadius = 8
        submitButton.layer.borderColor  = UIColor.lightTheme().cgColor
        submitButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        
        // Remove tableview footer to hide extra lines
        ratingOverviewTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
    @objc private func gotToLetsBeginScreen() {
        // Let's Begin Screen for Principal
        activityIndicator.stopAnimating()
        let letsBeginViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.letsBegin) as! LetsBeginViewController
        letsBeginViewController.user = user
        navigationController?.pushViewController(letsBeginViewController, animated: true)
    }
}

extension RatingOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return draggedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.ratingOverviewCell, for: indexPath) as! RatingOverviewTableViewCell
        if let expertType = allKeys?[indexPath.row], let tags = draggedCategories[expertType] {
            // Configure cell
            tableViewCell.set(tags: tags, for: expertType)
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
