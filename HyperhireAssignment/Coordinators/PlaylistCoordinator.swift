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
    private var container: DIContainer
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
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
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    func showSongList() {
        let searchSongUseCase = container.searchSongUseCase
        
        let viewModel = SongListViewModel(searchSongUseCase: searchSongUseCase)
        
        let viewController = SongListViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
    
    private func dismissSelf() {
        parentCoordinator?.childDidFinish(self)
    }
}



