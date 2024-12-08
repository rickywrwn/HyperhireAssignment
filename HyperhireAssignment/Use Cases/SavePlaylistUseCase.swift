//
//  SavePlaylistUseCase.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

protocol SavePlaylistUseCaseProtocol {
    func execute(name: String?, uid: String?, musicToSave: Results?) async -> Result<String, Error>
}

class SavePlaylistUseCaseImpl: SavePlaylistUseCaseProtocol {
    private let repository: PlaylistRepositoryProtocol
    
    init(repository: PlaylistRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String?, uid: String?, musicToSave: Results?) async -> Result<String, Error> {
        let result = await repository.savePlaylistsToCache(name: name, uid: uid, musicToSave: musicToSave)
        
        switch result {
        case .success(let resultData):
            return .success(resultData)
            
        case .failure(let error):
            print("use case error ", error.localizedDescription)
            return .failure(error)
        }
    }
}

