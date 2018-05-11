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
    
    // MARK: - Other Property
    
    var user:User! = User.loggedInUser()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get user
        
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
        
        carouselFlowLayout.scrollDirection = .horizontal
        var size    = questionCollectionView.frame.size
        size.width  = size.width - 60
        carouselFlowLayout.itemSize = size
        carouselFlowLayout.spacingMode = .fixed(spacing: 5)
        
        questionCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
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
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let questionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.questionCollectionViewCell, for: indexPath) as! QuestionCollectionViewCell
        return questionCollectionViewCell
    }
}
