//
//  LibraryViewModel.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol LibraryViewModelProtocol: AnyObject {
    var playlistData: [SavedPlaylist]? { get }
    var errorData: Error? { get }
    
    var onPlaylistDataChanged: (() -> Void)? { get set }
    var onErrorDataChanged: (() -> Void)? { get set }
    
    func viewDidAppear()
    func fetchPlaylist() async
}

final class LibraryViewModel: LibraryViewModelProtocol{
    
    private let getPlaylistUseCase: GetPlaylistUseCaseProtocol
    
    private(set) var playlistData: [SavedPlaylist]? {
        didSet {
            onPlaylistDataChanged?()
        }
    }
    
    private(set) var errorData: Error? {
        didSet {
            onErrorDataChanged?()
        }
    }
    
    // MARK: - Callbacks
    var onPlaylistDataChanged: (() -> Void)?
    var onErrorDataChanged: (() -> Void)?
    
    init(
        getPlaylistUseCase: GetPlaylistUseCaseProtocol
    ) {
        self.getPlaylistUseCase = getPlaylistUseCase
    }
    
    func viewDidAppear() {
        Task {
            await fetchPlaylist()
        }
    }
    
    @MainActor //main actor to make sure its on main thread
    func fetchPlaylist() async {
        let result = await getPlaylistUseCase.execute()
        
        switch result {
        case .success(let resultData):
            playlistData = resultData
            
        case .failure(let error):
            errorData = error
        }
    }
}

