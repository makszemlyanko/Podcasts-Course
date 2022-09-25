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
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    let playerDetailView = PlayerDetailView.initFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemPurple
        setupViewControllers()
        setupPlayerDetailView()
    }
    
    @objc func minimizePlayerDetail() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.playerDetailView.maximizedStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
        }
    }
    
    func maximizePlayerDetail(episode: Episode?) {
        self.playerDetailView.miniPlayerView.alpha = 0
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        if episode != nil {
            playerDetailView.episode = episode
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = true
            self.playerDetailView.maximizedStackView.alpha = 1
        }
    }
    
    private func setupPlayerDetailView() {
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)
        viewControllers = [
            createNavContoller(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            createNavContoller(for: favoritesController, title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            createNavContoller(for: DownloadsController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    private func createNavContoller(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
