//
//  ViewResponseViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 05/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import Koloda
import GrowingTextView

class ViewResponseViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var statementTextView: GrowingTextView!
    @IBOutlet weak var cardCollectionView: KolodaView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet var swipeLabels: [UILabel]!
    @IBOutlet var swipeImageViews: [UIImageView]!
    @IBOutlet weak var noResponsesLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var textViewContainerView: UIView!
    @IBOutlet weak var closeButton: SolviantButton!
    @IBOutlet weak var actionStackView: UIStackView!
    
    
    // MARK: - Other Property
    
    var user:User!
    let webManager = WebRequestManager()
    var selectedStatement:Statement!
    var responses:[Response]?
    var actionedResponses:[Response]?
    var swipesImages = [#imageLiteral(resourceName: "left_swipe"), #imageLiteral(resourceName: "down_swipe"), #imageLiteral(resourceName: "right_swipe")]
    var lastGetureDetectedOn = Date().timeIntervalSince1970
    var swipingDirection = SwipeActionDirection.none
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
        setupCardView()
        
        // Fetch responses for selected statement
        requestFetchStatements(with: selectedStatement.identifier, for: user.userId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProblemStatement()
    }
    
    // MARK: - IB Action
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undoCardSwipe(_ sender: Any) {
        guard !activityIndicator.isAnimating else {
            return
        }
        cardCollectionView.revertAction()
        actionedResponses?.removeLast()
        noResponsesLabel.isHidden    = true
        actionButtonView.isHidden     = false
        undoButton.isHidden           = actionedResponses!.count == 0
    }
    
    @IBAction func closeStatement(_ sender: Any) {
        guard !activityIndicator.isAnimating else {
            return
        }
        // Confirm close statement action first
        closeStatementConfirmation()
    }
    
    @IBAction func updateStatment(_ sender: Any) {
        guard !activityIndicator.isAnimating else {
            return
        }
        let createStatmentViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.createStatment) as! PostStatementViewController
        createStatmentViewController.selectedStatement = selectedStatement
        createStatmentViewController.user              = user
        present(createStatmentViewController, animated: true) {
            
        }
    }
    
    @IBAction func swipeCard(_ sender: UIButton) {
        guard !activityIndicator.isAnimating else {
            return
        }
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
            resetLabels()
        }
    }
    
    @IBAction func buttonHighlighted(_ sender: UIButton) {
        guard !activityIndicator.isAnimating else {
            return
        }
        if let swipeDirection = SwipeActionDirection(rawValue: sender.tag) {
            switch swipeDirection {
            case .left:
                highlightButton(forSwipe: .left)
            case .down:
                highlightButton(forSwipe: .down)
            case .right:
                highlightButton(forSwipe: .right)
            default:
                break
            }
        }
    }
    
    // MARK: - Utility
    
    private func customizeUI() {
        // Customize UI for theme appearance
        textViewContainerView.backgroundColor = .clear
        textViewContainerView.darkShadow(withRadius: 10)
        textViewContainerView.layer.cornerRadius = 8
        textViewContainerView.layer.backgroundColor = UIColor.white.cgColor
        textViewContainerView.layer.sublayers?.last?.cornerRadius = 8.0
        textViewContainerView.layer.sublayers?.last?.masksToBounds = true
    }
    
    private func setProblemStatement() {
        statementTextView.text = selectedStatement.problemText
    }
    
    private func setupCardView() {
        // Configure card view
        cardCollectionView.delegate   = self
        cardCollectionView.dataSource = self
    }
    
    private func closeStatementConfirmation() {
        // Show action alert for close statement
        weak var weakSelf = self
        let alertController = UIAlertController.init(title: NSLocalizedString("closeStatmentTitle", comment: ""), message: NSLocalizedString("closeStatmentMessage", comment: ""), preferredStyle: .actionSheet)
        let dismissAction   = UIAlertAction.init(title: NSLocalizedString("dontclose", comment: ""), style: .cancel) { (action) in
            weakSelf?.dismiss(animated: true, completion: {
                
            })
        }
        let closeAction = UIAlertAction.init(title: NSLocalizedString("close", comment: ""), style: .destructive) { (action) in
            weakSelf?.dismiss(animated: true, completion: {
            })
            weakSelf?.closeStatement(with: weakSelf!.selectedStatement.identifier)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(closeAction)
        present(alertController, animated: true) {
            
        }
    }
    
    private func highlightButton(forSwipe direction: SwipeResultDirection, completion percentage: CGFloat = 50) {
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
            if percentage < 100 {
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    }
    
}


extension ViewResponseViewController: KolodaViewDataSource, KolodaViewDelegate {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return responses?.count ?? 0
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = RespondCardView.init(frame: cardCollectionView.bounds)
        // Set card data
        if let datasource = responses, datasource.count > index  {
            let response = datasource[index]
            cardView.setCard(for: response)
        }
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        highlightButton(forSwipe: direction, completion: finishPercentage)
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .down]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        undoButton.isHidden = false
        if let datasource = responses, datasource.count > index {
            let draggedStatment = datasource[index]
            actionedResponses?.append(draggedStatment)
            if koloda.isRunOutOfCards {
                actionStackView.isHidden = true
                noResponsesLabel.text = NSLocalizedString("greatJobPrincipal", comment: "")
                noResponsesLabel.isHidden = false
            }
            
            // Record swipe
            var swipeDirection:SwipeActionDirection?
            switch direction {
            case .left:
                swipeDirection = .left
            case .right:
                swipeDirection = .right
            case .down:
                swipeDirection = .down
                break
            default:
                break
            }
            
            if let direction = swipeDirection {
                // Update recorded swipe
                var parameters:[String:Any]                = Dictionary()
                parameters[APIKeys.status]                 =  direction.rawValue
                parameters[PostStatementKey.principle]     = user.userId
                requestRecordSwipe(response: draggedStatment.identifier, parameter: parameters)
            }
            
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


extension ViewResponseViewController {
    
    // MARK: - Network Request
    
    private func requestFetchStatements(with statement: String, for principal: String) {
        // Request fetch all statement
        activityIndicator.startAnimating()
        let apiEndPoint = APIEndPoint.fetchResponse(with: principal, statementId: statement)
        let apiURL = APIURL.statementUrl(apiEndPoint: apiEndPoint)
        weak var weakSelf = self
        webManager.httpRequest(method: .get, apiURL: apiURL, body: [:], completion: { (response) in
            weakSelf?.didFetch(statements: response)
        }) { (error) in
            weakSelf?.activityIndicator.stopAnimating()
        }
    }
    
    private func closeStatement(with statement: String) {
        // Request close statement
        cardCollectionView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let apiURL = APIURL.statementUrl(apiEndPoint: APIEndPoint.closeStatement + statement)
        weak var weakSelf = self
        webManager.httpRequest(method: .delete, apiURL: apiURL, body: [:], completion: { (response) in
            // Statement closed successfully
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in
            // Statement failed to close
            weakSelf?.cardCollectionView.isUserInteractionEnabled = true
            weakSelf?.activityIndicator.stopAnimating()
        }
    }
    
    private func requestRecordSwipe(response identifier:String, parameter: Dictionary<String, Any>) {
        // Request fetch all statement
        let apiURL = APIURL.statementUrl(apiEndPoint: APIEndPoint.responseSwipe) + identifier
        webManager.httpRequest(method: .post, apiURL: apiURL, body: parameter, completion: { (response) in
            // Recorded statement
        }) { (error) in
            
        }
    }
    
    // MARK: - Request Completion
    
    private func didFetch(statements: Dictionary<String, Any>) {
        if let resultArray = statements[APIKeys.result] as? Array<Dictionary<String, Any>> {
            self.responses = Array()
            self.actionedResponses = Array()
            for resourceInfo in resultArray {
                if let response = Response.init(with: resourceInfo) {
                    self.responses?.append(response)
                }
            }
            
            perform(#selector(shouldHide), with: self, afterDelay: 2)
        }
        
        // Reload cards
        cardCollectionView.reloadData()
    }
    
    @objc private func shouldHide() {
        activityIndicator.stopAnimating()
        if self.responses != nil && self.responses!.count > 0 {
            noResponsesLabel.isHidden   = true
            cardCollectionView.isHidden = false
            actionStackView.isHidden    = false
        }
        else {
            noResponsesLabel.isHidden       = false
            cardCollectionView.isHidden     = true
            actionStackView.isHidden        = true
        }
        actionButtonView.isHidden   = false
    }
    
}
