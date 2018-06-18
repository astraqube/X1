//
//  SideMenuViewController.swift
//  Solviant
//
//  Created by Rohit Kumar on 13/06/2018.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {

    // MARK: - IB Outlet
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    // MARK: - Other Property
    
    private var user = User.loggedInUser()
    private var optionImages    = [#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "user"), #imageLiteral(resourceName: "feed"), #imageLiteral(resourceName: "calendar"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "payment"), #imageLiteral(resourceName: "settings"), #imageLiteral(resourceName: "switch_profile"), #imageLiteral(resourceName: "logout")]
    private var optionTitles    = ["home", "profile", "feedback", "consult", "requestToBeRated", "paymentDetails", "settings", "switchProfile", "logout"]
    private enum MenuIndex: Int {
        case home, profile, feedback, consult, requestToBeRated, paymentDetails, settings, switchProfile, logout
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserData()
    }
    
    // MARK: - Utility
    
    private func setUserData() {
        // Set user profile
        usernameLabel.text = user?.name
        userLocationLabel.text = user?.city
        if let imageURL = user?.imageURL {
            userImageView.setImage(withURL: imageURL, placeholder: #imageLiteral(resourceName: "user-icon"))
        }
    }
    
    private func customizeUI() {
        // Set theme apperance
        SideMenuManager.default.menuWidth = 300;
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.white
        self.gradientView.applyGradient(colours: [UIColor.darkTheme(), UIColor.lightTheme()])
        self.headerView.darkShadow(withRadius: 20)
    }
}

extension SideMenuViewController {
    
    // MARK - Menu Option Actions
    
    private func logout() {
        user?.delete()
        let landingViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.landing)
        let rootViewController    = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController
        rootViewController.setViewControllers([landingViewController!], animated: false)
        dismiss(animated: true) {
            
        }
    }
    
    private func navigateToProfile() {
        // Go to User profile screen
        dismiss(animated: true) {
                
        }
        let rootViewController    = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.profile) as! ProfileViewController
        profileViewController.user = user
        rootViewController.present(profileViewController, animated: true) {
            
        }
    }
    
    private func navigateToConsult() {
        // Go to User profile screen
//        dismiss(animated: true) {
//            
//        }
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryboardName.meetingFlow, bundle:nil)
        var nextViewController : UIViewController?
        if user?.type == .principal {
            nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: PrincipalStatementDetailViewController.self)) as! PrincipalStatementDetailViewController
        }
        else{
            nextViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: StatementDetailViewController.self)) as! StatementDetailViewController
        }
        self.present(nextViewController!, animated:true, completion:nil)
    }
    
    
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.sideMenuTableViewCell) as! SideMenuOptionTableViewCell
        sideMenuTableViewCell.optionLabel.text      = NSLocalizedString(optionTitles[indexPath.row], comment: "")
        sideMenuTableViewCell.optionImageView.image = optionImages[indexPath.row]
        return sideMenuTableViewCell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate user to selected screen
        if let menuInex = MenuIndex(rawValue: indexPath.row) {
            switch menuInex {
            case .profile:
                navigateToProfile()
            case .consult:
                navigateToConsult()
                break;
            case .logout:
                // Clear session and back to Landing Screen
                logout()
            default:
                break
            }
        }
    }
}


