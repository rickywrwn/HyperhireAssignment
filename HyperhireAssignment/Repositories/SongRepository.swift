//
//  SongRepository.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol SongRepositoryProtocol {
    func fetchSearchSong(search: String) async -> Result<[Results], NetworkError>
}

class SongRepositoryImpl: SongRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let cacheKey = "cached_categories"
    
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func fetchSearchSong(search: String) async -> Result<[Results], NetworkError> {
        
        let endpoint = APIEndpoint(
            path: "/search",
            method: .get,
            parameters: [
                        "term": search,
                        "media": "music"
                        ]
        )
        
        let result: Result<ItunesResponse, NetworkError> = await networkService.request(endpoint: endpoint)
        
        switch result {
        case .success(let response):
            let searchResult = response.results ?? []
            return .success(searchResult)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
