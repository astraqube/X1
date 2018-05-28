//
//  OpenStatementViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 28/05/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Koloda
import pop

class OpenStatementViewController: UIViewController {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var cardCollectionView: KolodaView!
    @IBOutlet var statementCardView: UIView!
    @IBOutlet weak var respondButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet var swipeLabels: [UILabel]!
    @IBOutlet var swipeImageViews: [UIImageView]!
    
    
    // MARK: - Other Property
    
    var user:User!
    let webManager = WebRequestManager()
    var statements:[Statement]?
    var actionedStatements:[Statement]?
    var swipesImages = [#imageLiteral(resourceName: "left_swipe"), #imageLiteral(resourceName: "down_swipe"), #imageLiteral(resourceName: "right_swipe")]
    var lastGetureDetectedOn = Date().timeIntervalSince1970
    var swipingDirection = SwipeActionDirection.none
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        customizeUI()
        setupCardView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch user statements
        requestFetchStatements()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
    }
    
    // MARK: - IB Action
    
    @IBAction func respondToStatement(_ sender: Any) {
    }
    
    
    @IBAction func undoCardSwipe(_ sender: Any) {
        cardCollectionView.revertAction()
        if var draggedStements = actionedStatements, draggedStements.count > 0 {
            _ = draggedStements.removeLast()
            undoButton.isHidden = draggedStements.count > 0
        }
    }
    
    
    @IBAction func swipeCard(_ sender: UIButton) {
        if let swipeDirection = SwipeActionDirection(rawValue: sender.tag) {
            switch swipeDirection {
            case .left:
                cardCollectionView.swipe(.left)
            case .down:
                cardCollectionView.swipe(.down)
            case .right:
                cardCollectionView.swipe(.right)
            default:
                break
            }
        }
    }
    
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Customize Button
        respondButton.backgroundColor = .clear
        respondButton.darkShadow(withRadius: 5)
        respondButton.layer.borderWidth = 1.0
        respondButton.layer.cornerRadius = 8
        respondButton.layer.backgroundColor = UIColor.white.cgColor
        respondButton.layer.sublayers?.last?.cornerRadius = 8.0
        respondButton.layer.sublayers?.last?.masksToBounds = true
        respondButton.layer.borderColor  = UIColor.lightTheme().cgColor
        respondButton.setTitleColor(UIColor.darkTheme(), for: .normal)
        

        statementCardView.backgroundColor = .clear
        statementCardView.darkShadow(withRadius: 10)
        statementCardView.layer.cornerRadius = 8
        statementCardView.layer.backgroundColor = UIColor.white.cgColor
        statementCardView.layer.sublayers?.last?.cornerRadius = 8.0
        statementCardView.layer.sublayers?.last?.masksToBounds = true
    }
    
    private func setupCardView() {
        // Configure card view
        cardCollectionView.delegate  = self
        cardCollectionView.dataSource = self
    }

}

extension OpenStatementViewController: KolodaViewDataSource, KolodaViewDelegate {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return statements?.count ?? 0
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = StatementCardView.init(frame: statementCardView.bounds)
        // Set card data
        if let datasource = statements, datasource.count > index  {
             let statement = datasource[index]
            cardView.setCard(for: statement)
        }
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        var label:UILabel?
        var imageView:UIImageView?
        var selectedImage:UIImage?
        var unSelectedImage:UIImage?
        var dragDirection = SwipeActionDirection.none
        switch direction {
        case .left:
            label     = swipeLabels[SwipeActionDirection.left.rawValue]
            imageView = swipeImageViews[SwipeActionDirection.left.rawValue]
            selectedImage   = #imageLiteral(resourceName: "left_swipe_select")
            unSelectedImage = #imageLiteral(resourceName: "left_swipe")
            dragDirection = .left
        case .right:
            label     = swipeLabels[SwipeActionDirection.right.rawValue]
            imageView = swipeImageViews[SwipeActionDirection.right.rawValue]
            selectedImage = #imageLiteral(resourceName: "right_swipe_select")
            unSelectedImage = #imageLiteral(resourceName: "right_swipe")
            dragDirection = .right
        case .down:
            label     = swipeLabels[SwipeActionDirection.down.rawValue]
            imageView = swipeImageViews[SwipeActionDirection.down.rawValue]
            selectedImage = #imageLiteral(resourceName: "down_swipe_select")
            unSelectedImage = #imageLiteral(resourceName: "down_swipe")
            dragDirection = .down
            break
        default:
            break
        }
        
        if swipingDirection != dragDirection {
            swipingDirection = dragDirection
            resetLabels()
        }
        
        if let selectedLabel = label, let selectedImageView = imageView {
            if finishPercentage < 100 {
                selectedLabel.textColor = UIColor.darkTheme()
                selectedImageView.image = selectedImage
            }
            else {
                selectedLabel.textColor = .lightGray
                selectedImageView.image = unSelectedImage
            }
        }
        
        // Reset labels if gesture was not detected for one or more second 
        let currentTimerInteval = Date().timeIntervalSince1970
        if  currentTimerInteval - lastGetureDetectedOn > 1 {
            Thread.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(resetLabels), with: self, afterDelay: 1)
        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .down]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        undoButton.isHidden = false
        if let datasource = statements, datasource.count > index {
            let draggedStatment = datasource[index]
            actionedStatements?.append(draggedStatment)
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    @objc func resetLabels() {
        for label in swipeLabels {
            label.textColor = .lightGray
        }
        let count = swipeImageViews.count
        for index in 0..<count {
            swipeImageViews[index].image = swipesImages[index]
        }
    }
    
}

extension OpenStatementViewController {
    
    // MARK: - Network Request
    
    private func requestFetchStatements() {
        // Request fetch all statement
        activityIndicator.startAnimating()
        let apiURL = APIURL.statementUrl(apiEndPoint: APIEndPoint.fetchPosts)
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
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
            self.actionedStatements = Array()
            actionButtonView.isHidden = false
            for statementInfo in resultArray {
                if let statement = Statement.init(with: statementInfo) {
                    self.statements?.append(statement)
                }
            }
        }
        
        // Reload cards
        cardCollectionView.reloadData()
    }
    
}


