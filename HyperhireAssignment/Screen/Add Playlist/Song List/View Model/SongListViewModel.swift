//
//  SongListViewModel.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

// MARK: - ViewModel Protocol
protocol SongListViewModelProtocol: AnyObject {
    var musicData: [Results]? { get }
    
    var onMusicDataChanged: (() -> Void)? { get set }
    
    func viewDidLoad()
    func fetchSong(search: String) async
}

final class SongListViewModel: SongListViewModelProtocol{
    
    private let searchSongUseCase: SearchSongUseCaseProtocol
    
    private(set) var musicData: [Results]? {
        didSet {
            onMusicDataChanged?()
        }
    }
    
    // MARK: - Callbacks
    var onMusicDataChanged: (() -> Void)?
    
    init(
        searchSongUseCase: SearchSongUseCaseProtocol
    ) {
        self.searchSongUseCase = searchSongUseCase
    }
    
    func viewDidLoad() {
        
    }
    
    @MainActor //main actor to make sure its on main thread
    func fetchSong(search: String) async {
        let result = await searchSongUseCase.execute(search: search)
        
        switch result {
        case .success(let searchedSong):
            musicData = searchedSong
            
        case .failure(let error):
            print(error)
        }
    }

}

