//
//  LibraryCoordinator.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

import UIKit

class LibraryCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var container: DIContainer
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewController = LibraryViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showAddPlaylist (){
        let addPlaylistCoordinator = PlaylistCoordinator(
            navigationController: navigationController,
            container: container
        )
        addPlaylistCoordinator.parentCoordinator = self
        childCoordinators.append(addPlaylistCoordinator)
        addPlaylistCoordinator.start()
        
    }
}


