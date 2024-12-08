//
//  DIContainerFactory.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

// MARK: - Factory Protocol
protocol DIContainerFactory {
    func makeNetworkService() -> NetworkServiceProtocol
    func makeCacheService() -> CacheServiceProtocol
    func makeSongRepository(networkService: NetworkServiceProtocol) -> SongRepositoryProtocol
    func makePlaylistRepository(cacheService: CacheServiceProtocol) -> PlaylistRepositoryProtocol
}

class DIFactory: DIContainerFactory {
    
    func makeNetworkService() -> NetworkServiceProtocol {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        let session = URLSession(configuration: configuration)
        return NetworkService(
            session: session
        )
    }
    
    func makeCacheService() -> CacheServiceProtocol {
        return try! CacheService()
    }
    
    func makeSongRepository(networkService: NetworkServiceProtocol) -> SongRepositoryProtocol {
        return SongRepositoryImpl(networkService: networkService)
    }
    
    func makePlaylistRepository(cacheService: CacheServiceProtocol) -> PlaylistRepositoryProtocol {
        return PlaylistRepositoryImpl(cacheService: cacheService)
    }
}

