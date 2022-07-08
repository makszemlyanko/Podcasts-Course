//
//  MainTabBarController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 07.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple
        
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
