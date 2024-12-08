//
//  DetailPlaylistViewModel.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol DetailPlaylistViewModelProtocol: AnyObject {
    var playlistData: [SavedPlaylist]? { get }
    var errorData: Error? { get }
    
    var onPlaylistDataChanged: (() -> Void)? { get set }
    var onErrorDataChanged: (() -> Void)? { get set }
    
    func viewDidLoad()
    func fetchPlaylist() async
    func savePlaylist(name: String?, uid: String?, musicToSave: Results?) async
}

final class DetailPlaylistViewModel: DetailPlaylistViewModelProtocol{
    
    private let getPlaylistUseCase: GetPlaylistUseCaseProtocol
    private let savePlaylistUseCase: SavePlaylistUseCaseProtocol
    private var titleFromAddPlaylist: String?
    
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
        getPlaylistUseCase: GetPlaylistUseCaseProtocol,
        savePlaylistUseCase: SavePlaylistUseCaseProtocol,
        titleFromAddPlaylist: String? = nil
    ) {
        self.getPlaylistUseCase = getPlaylistUseCase
        self.savePlaylistUseCase = savePlaylistUseCase
        self.titleFromAddPlaylist = titleFromAddPlaylist
    }
    
    func viewDidLoad() {
        Task {
            await fetchPlaylist()
        }
    }
    
    @MainActor //main actor to make sure its on main thread
    func fetchPlaylist() async {
        let result = await getPlaylistUseCase.execute()
        
        switch result {
        case .success(let resultData):
            print("mvvm success ", resultData)
            playlistData = resultData
            
        case .failure(let error):
            errorData = error
        }
    }
    
    @MainActor //main actor to make sure its on main thread
    func savePlaylist(name: String? = nil, uid: String? = nil, musicToSave: Results? = nil) async {
        let result = await savePlaylistUseCase.execute(name: name, uid: uid, musicToSave: musicToSave)
        
        switch result {
        case .success(let resultData):
            print("mvvm success ", resultData)
            
        case .failure(let error):
            errorData = error
        }
    }
}
 
