//
//  UnresolvedStatementViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 08/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class UnresolvedStatementViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var viewResponseButton: UIButton!
    @IBOutlet weak var statementCollectionView: UICollectionView!
    @IBOutlet weak var noOpenStatementLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var carouselFlowLayout: UPCarouselFlowLayout!
    
    // MARK: - Other Property
    
    var user:User!
    let webManager = WebRequestManager()
    var statements:[Statement]?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tabBarController = self.tabBarController as? HomeTabBarViewController {
            user = tabBarController.user
        }
        
        // Configure UI
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestFetchStatements(for: user.userId)
    }
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        // Configure CollectionView Layout
        var size    = statementCollectionView.frame.size
        size.width  = size.width - 60
        size.height -= 5
        carouselFlowLayout.itemSize = size
        carouselFlowLayout.spacingMode = .fixed(spacing: 5)
        carouselFlowLayout.scrollDirection = .horizontal
    }
    
    // MARK: - IB Action
    
    @IBAction func openMenu(_ sender: Any) {
        // Log out user temporarily
        user.delete()
        let landingViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.landing)
        navigationController?.setViewControllers([landingViewController!], animated: true)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let viewResponseViewController = segue.destination as? ViewResponseViewController {
            if let centerIndexPath = statementCollectionView.centerCellIndexPath, let statement = statements?[centerIndexPath.item] {
                viewResponseViewController.selectedStatement = statement
                viewResponseViewController.user              = user
            }
        }
    }
}

extension UnresolvedStatementViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let questionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.questionCollectionViewCell, for: indexPath) as! QuestionCollectionViewCell
        // Configure cell with data
        if let statement = statements?[indexPath.item] {
            questionCollectionViewCell.configureCell(with: statement)
        }
        return questionCollectionViewCell
    }

}

extension UnresolvedStatementViewController {
    
    // MARK: - Network Request
    
    private func requestFetchStatements(for principal: String) {
        // Request fetch all statement
        if statements == nil {
            activityIndicator.startAnimating()
        }
        let apiEndPoint = APIEndPoint.statement(with: principal)
        let apiURL = APIURL.statementUrl(apiEndPoint: apiEndPoint)
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.didFetch(statements: response)
        }) { (error) in
            weakSelf?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Request Completion
    
    private func didFetch(statements: Dictionary<String, Any>) {
        activityIndicator.stopAnimating()
        if let resultArray = statements[APIKeys.result] as? Array<Dictionary<String, Any>> {
            self.statements = Array()
            for statementInfo in resultArray {
                var statemenToShow = statementInfo
                if let redefinedStatments = statementInfo[APIKeys.redefinedStatment] as? Array<Dictionary<String, Any>>,
                    let redifinedStatement = redefinedStatments.last {
                    // Show redefined statement
                    statemenToShow = redifinedStatement
                }
                if let statement = Statement.init(my: statemenToShow), let originalIdentifier = statementInfo[PostStatementKey.identifier] as? String {
                    self.statements?.append(statement)
                    statement.identifier = originalIdentifier
                }
            }
            
            // Reload collectionview
            statementCollectionView.reloadData()
            if self.statements!.count == 0 {
                noOpenStatementLabel.isHidden    = false
                statementCollectionView.isHidden = true
                viewResponseButton.isHidden      = true
            }
            else {
                noOpenStatementLabel.isHidden    = true
                statementCollectionView.isHidden = false
                viewResponseButton.isHidden      = false
            }
        }
    }
    
}
