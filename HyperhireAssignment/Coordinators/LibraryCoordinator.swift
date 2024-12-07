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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LibraryViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showAddPlaylist (){
        let addPlaylistCoordinator = PlaylistCoordinator(
            navigationController: navigationController
        )
        addPlaylistCoordinator.parentCoordinator = self
        childCoordinators.append(addPlaylistCoordinator)
        addPlaylistCoordinator.start()
        
    }
}


