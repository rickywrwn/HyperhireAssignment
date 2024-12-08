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
        let getPlaylistUseCase = container.getPlaylistUseCase
        
        let viewModel = LibraryViewModel(getPlaylistUseCase: getPlaylistUseCase)
        
        let viewController = LibraryViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showAddPlaylist (){
        let playlistCoordinator = PlaylistCoordinator(
            navigationController: navigationController,
            container: container
        )
        playlistCoordinator.parentCoordinator = self
        childCoordinators.append(playlistCoordinator)
        playlistCoordinator.start()
        
    }
    
    func showDetailPlaylist (with playlistUid: String){
        let playlistCoordinator = PlaylistCoordinator(
            navigationController: navigationController,
            container: container
        )
        playlistCoordinator.parentCoordinator = self
        childCoordinators.append(playlistCoordinator)
        playlistCoordinator.showDetailPlaylist(playlistUid: playlistUid)
        
    }
}


