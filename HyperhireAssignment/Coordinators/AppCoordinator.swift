//
//  AppCoordinator.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

class AppCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let tabBarController = TabBarController()
        setupTabs(tabBarController)
        tabBarController.selectedIndex = 2 //change tab to your library
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabs(_ tabBarController: TabBarController) {
        
        let homeCoordinator = LibraryCoordinator(
            navigationController: UINavigationController()
        )
        
        let searchCoordinator = LibraryCoordinator(
            navigationController: UINavigationController()
        )
        
        let libraryCoordinator = LibraryCoordinator(
            navigationController: UINavigationController()
        )
        
        childCoordinators = [homeCoordinator, searchCoordinator, libraryCoordinator]
        
        childCoordinators.forEach { coordinator in
            coordinator.parentCoordinator = self
            coordinator.start()
        }
        
        tabBarController.setViewControllers(
            childCoordinators.map { $0.navigationController },
            animated: false
        )
        
        // Set tab bar items
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: ImageManager.image(for: .homeIcon),
            tag: 0
        )
        
        searchCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Search",
            image: ImageManager.image(for: .searchIcon),
            tag: 1
        )
        
        libraryCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Your Library",
            image: ImageManager.image(for: .libraryIcon),
            tag: 2
        )
    }
}

