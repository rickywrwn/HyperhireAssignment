//
//  PlaylistCoordinator.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

class PlaylistCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAddPlaylist()
    }
    
    private func showAddPlaylist() {
        let viewController = AddPlaylistViewController()
        viewController.coordinator = self
        navigationController.present(viewController, animated: true)
        
    }
    
    func showDetailPlaylist() {
        let viewController = DetailPlaylistViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    private func dismissSelf() {
        parentCoordinator?.childDidFinish(self)
    }
}



