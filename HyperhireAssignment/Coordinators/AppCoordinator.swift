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
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLibraryView()
    }
    
    private func showLibraryView() {
        let libraryCoordinator = LibraryCoordinator(
            navigationController: navigationController
        )
        libraryCoordinator.parentCoordinator = self
        childCoordinators.append(libraryCoordinator)
        libraryCoordinator.start()
    }
}

