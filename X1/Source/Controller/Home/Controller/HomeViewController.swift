//
//  HomeViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 02/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class HomeViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var askAnythingButton: UIButton!
    @IBOutlet weak var viewResponseButton: UIButton!
    @IBOutlet weak var answerNowButtonContaierView: UIView!
    @IBOutlet weak var answerNowButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var carouselFlowLayout: UPCarouselFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noStatementLabel: UILabel!
    
    // MARK: - Other Property
    
    var user:User! = User.loggedInUser()
    let webManager = WebRequestManager()
    var statements:[Statement]?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigne logged in user
        if let tabBarController = self.tabBarController as? HomeTabBarViewController {
            tabBarController.user = user
        }
        
        // Customize UI
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (user.type == .principal) {
            answerNowButtonContaierView.isHidden = true
            stackView.isHidden                   = false
        }
        else {
            stackView.isHidden                   = true
            answerNowButtonContaierView.isHidden = false
        }
        
        // Refresh statements
       /* if user.type != .principal {
            requestFetchStatements()
        } */
    }
    
    // MARK: - Customize UI
    
    private func customizeUI() {
        // Customize for theme appearance
        separatorView.darkShadow(withRadius: 0.8, color: UIColor.lightGray.withAlphaComponent(0.5))
        badgeCountLabel.layer.cornerRadius  = 9
        badgeCountLabel.layer.masksToBounds = true
        
        askAnythingButton.layer.borderWidth = 1.0
        askAnythingButton.layer.borderColor = UIColor.lightTheme().cgColor
        askAnythingButton.darkShadow(withRadius: 5)
        answerNowButton.layer.borderWidth = 1.0
        answerNowButton.layer.borderColor = UIColor.lightTheme().cgColor
        answerNowButton.darkShadow(withRadius: 5)
        viewResponseButton.layer.borderWidth = 1.0
        viewResponseButton.layer.borderColor = UIColor.lightTheme().cgColor
        viewResponseButton.darkShadow(withRadius: 5)
        var size    = questionCollectionView.frame.size
        size.width  = size.width - 60
        size.height -= 5
        carouselFlowLayout.itemSize = size
        carouselFlowLayout.spacingMode = .fixed(spacing: 5)
        carouselFlowLayout.scrollDirection = .horizontal
    }
    
    
    // MARK: - IB Action
    
    @IBAction func openMenu(_ sender: Any) {
        // Log out user temporarily
//        user.delete()
//        let landingViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.landing)
//        navigationController?.setViewControllers([landingViewController!], animated: true)
        
        self.moveOnStatementDetail()
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let destinationController = segue.destination as? PostStatementViewController {
            destinationController.user = user
        }
        else if let destinationController = segue.destination as? OpenStatementViewController {
            destinationController.user = user
        }
    }
    
    // TODO: remove code from here

    //MARK: - This is temporary whenever storybord link with main it will remove from code
    
    func moveOnStatementDetail(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "MeetingFlow", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: StatementDetailViewController.self)) as! StatementDetailViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension HomeViewController {
    
    // MARK: - Network Request
    
    private func requestFetchStatements() {
        // Request fetch all statement
        activityIndicator.startAnimating()
        let apiURL = APIURL.statementUrl(apiEndPoint: APIEndPoint.fetchPosts)
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
        if let resultArray = statements[APIKeys.result] as? Array<Dictionary<String, Any>> {
            self.statements = Array()
            for statementInfo in resultArray {
                if let statement = Statement.init(with: statementInfo) {
                    self.statements?.append(statement)
                }
            }
            
            // Reload collectionview
            questionCollectionView.reloadData()
            if self.statements!.count > 1 {
                questionCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredVertically, animated: false)
            }
        }
    }
    
}
