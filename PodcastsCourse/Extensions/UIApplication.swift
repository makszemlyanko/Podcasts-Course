//
//  UIApplication.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 28.07.2022.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        return shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? MainTabBarController
    }
}
