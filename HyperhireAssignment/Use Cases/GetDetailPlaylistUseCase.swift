//
//  GetDetailPlaylistUseCase.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol GetDetailPlaylistUseCaseProtocol {
    func execute(playlistUid: String) async -> Result<SavedPlaylist, CacheError>
}

class GetDetailPlaylistUseCaseImpl: GetDetailPlaylistUseCaseProtocol {
    private let repository: PlaylistRepositoryProtocol
    
    init(repository: PlaylistRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(playlistUid: String) async -> Result<SavedPlaylist, CacheError> {
        let result = await repository.retrievePlaylistWithUid(playlistUid: playlistUid)
        
        switch result {
        case .success(let resultData):
            return .success(resultData)
            
        case .failure(let error):
            print("use case error ", error.localizedDescription)
            return .failure(error)
        }
    }
}
