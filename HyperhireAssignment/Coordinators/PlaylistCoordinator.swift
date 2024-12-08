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
    
    func showDetailPlaylist(title: String? = nil, playlistUid: String? = nil) {
        let getPlaylistUseCase = container.getPlaylistUseCase
        let savePlaylistUseCase = container.savePlaylistUseCase
        let getDetailPlaylistUseCase = container.getDetailPlaylistUseCase
        
        let viewModel = DetailPlaylistViewModel(
                            getPlaylistUseCase: getPlaylistUseCase,
                            savePlaylistUseCase: savePlaylistUseCase,
                            getDetailPlaylistUseCase: getDetailPlaylistUseCase,
                            titleFromAddPlaylist: title,
                            playlistUid: playlistUid)
        
        let viewController = DetailPlaylistViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    func showSongList(withParentDelegate: DetailPlaylistViewController) {
        let searchSongUseCase = container.searchSongUseCase
        
        let viewModel = SongListViewModel(searchSongUseCase: searchSongUseCase)
        
        let viewController = SongListViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewController.addMusicDelegate = withParentDelegate
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



