//
//  GetPlaylistUseCase.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol GetPlaylistUseCaseProtocol {
    func execute() async -> Result<[SavedPlaylist], CacheError>
}

class GetPlaylistUseCaseImpl: GetPlaylistUseCaseProtocol {
    private let repository: PlaylistRepositoryProtocol
    
    init(repository: PlaylistRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<[SavedPlaylist], CacheError> {
        let result = await repository.retrievePlaylistFromCache()
        
        switch result {
        case .success(let resultData):
            return .success(resultData)
            
        case .failure(let error):
            print("use case error ", error.localizedDescription)
            return .failure(error)
        }
    }
}
