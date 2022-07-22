//
//  MainTabBarController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 07.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .systemPurple
        
        setupViewControllers()
        
        setupPlayerDetailView()
        
        perform(#selector(minimizePlayerDetail), with: nil, afterDelay: 1)
    }
    
    // MARK: - Setup Functions
    
    @objc func minimizePlayerDetail() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func maximizePlayerDetail() {
        
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setupPlayerDetailView() {
        let playerDetailView = PlayerDetailView.initFromNib()
        playerDetailView.backgroundColor = .green
        
        // Use Auto Layout
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        // Enable Auto Layout
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint.isActive = true
        
    
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        
        
        
    }
    
    fileprivate func setupViewControllers() {
        viewControllers = [
            createNavContoller(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            createNavContoller(for: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            createNavContoller(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    fileprivate func createNavContoller(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
