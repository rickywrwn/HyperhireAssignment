//
//  TabBarController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

// MARK: - Main TabBar Controller
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .primaryTextColor
        tabBar.barTintColor = .secondaryTextColor
        tabBar.backgroundColor = .backgroundColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .backgroundColor
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // if code below removed, when we change tab on tab bar, view will blinks
    // iOS 18 bug
    // source: https://stackoverflow.com/a/79230169
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.setAnimationsEnabled(false)
    }
}

