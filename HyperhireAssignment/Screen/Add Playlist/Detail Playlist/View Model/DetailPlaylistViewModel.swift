//
//  DetailPlaylistViewModel.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol DetailPlaylistViewModelProtocol: AnyObject {
    var playlistData: SavedPlaylist? { get }
    var AllPlaylistData: [SavedPlaylist]? { get }
    var errorData: Error? { get }
    
    var onPlaylistDataChanged: (() -> Void)? { get set }
    var onErrorDataChanged: (() -> Void)? { get set }
    
    func viewDidLoad()
//    func fetchPlaylist() async
    func fetchPlaylistWithUid(with playlistUid: String) async
    func savePlaylist(name: String?, uid: String?, musicToSave: Results?) async
    
    func saveMusicToPlaylist(withMusic music: Results)
}

final class DetailPlaylistViewModel: DetailPlaylistViewModelProtocol{
    
    private let getPlaylistUseCase: GetPlaylistUseCaseProtocol
    private let savePlaylistUseCase: SavePlaylistUseCaseProtocol
    private let getDetailPlaylistUseCase: GetDetailPlaylistUseCaseProtocol
    
    private var playlistUid: String?
    private var titleFromAddPlaylist: String?
    
    private(set) var AllPlaylistData: [SavedPlaylist]?
    
    private(set) var playlistData: SavedPlaylist? {
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
        getDetailPlaylistUseCase: GetDetailPlaylistUseCaseProtocol,
        titleFromAddPlaylist: String? = nil,
        playlistUid: String? = nil
    ) {
        self.getPlaylistUseCase = getPlaylistUseCase
        self.savePlaylistUseCase = savePlaylistUseCase
        self.getDetailPlaylistUseCase = getDetailPlaylistUseCase
        self.playlistUid = playlistUid
        self.titleFromAddPlaylist = titleFromAddPlaylist
    }
    
    func viewDidLoad() {
        //if titleFromAddPlaylist exist, then it means user add new playlist
        //save new playlist
        if let playlistTitle = titleFromAddPlaylist{
            saveNewPlaylist(withTitle: playlistTitle)
        }else{
            //open existing detail playlist
            Task {
                await fetchPlaylistWithUid(with: playlistUid ?? "")
            }
        }
    }
    
    func saveMusicToPlaylist(withMusic music: Results) {
        Task {
            await savePlaylist(uid: playlistUid, musicToSave: music)
            await fetchPlaylistWithUid(with: playlistUid ?? "")
        }
    }
    
    private func saveNewPlaylist(withTitle playlistTitle: String) {
        Task {
            await savePlaylist(name: playlistTitle)
            await fetchPlaylistWithUid(with: playlistUid ?? "")
        }
    }
    
    @MainActor  //main actor to make sure its on main thread
    func fetchPlaylistWithUid(with playlistUid: String) async {
        let result = await getDetailPlaylistUseCase.execute(playlistUid: playlistUid)
        
        switch result {
        case .success(let resultData):
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
            // if playlistUid nil then save new playlist with title only
            if playlistUid == nil {
                //save new playlist
                playlistUid = resultData
            }
        case .failure(let error):
            errorData = error
        }
    }
}
 
