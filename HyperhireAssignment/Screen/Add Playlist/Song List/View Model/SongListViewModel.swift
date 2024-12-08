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
    var errorData: Error? { get }
    
    var onMusicDataChanged: (() -> Void)? { get set }
    var onErrorDataChanged: (() -> Void)? { get set }
    
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
    
    private(set) var errorData: Error? {
        didSet {
            onErrorDataChanged?()
        }
    }
    
    // MARK: - Callbacks
    var onMusicDataChanged: (() -> Void)?
    var onErrorDataChanged: (() -> Void)?
    
    init(
        searchSongUseCase: SearchSongUseCaseProtocol
    ) {
        self.searchSongUseCase = searchSongUseCase
    }
    
    func viewDidLoad() {
        
    }
    
    @MainActor //main actor to make sure its on main thread
    func fetchSong(search: String) async {
        if search.isEmpty{
            //when search is empty, remove all music data and don't call api
            musicData?.removeAll()
        }else{
            //call API when search query is not empty
            let result = await searchSongUseCase.execute(search: search)
            
            switch result {
            case .success(let searchedSong):
                musicData = searchedSong
                
            case .failure(let error):
                errorData = error
            }
        }
    }

}

