//
//  SearchSongUseCase.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol SearchSongUseCaseProtocol {
    func execute(search: String) async -> Result<[Results], NetworkError>
}

class SearchSongUseCaseImpl: SearchSongUseCaseProtocol {
    private let repository: SongRepositoryProtocol
    
    init(repository: SongRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(search: String) async -> Result<[Results], NetworkError> {
        let result = await repository.fetchSearchSong(search: search)
        
        switch result {
        case .success(let resultData):
            return .success(resultData)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
