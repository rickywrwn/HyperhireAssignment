//
//  DIContainer.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

final class DIContainer {
    private let factory: DIContainerFactory
    
    let networkService: NetworkServiceProtocol
    let cacheService: CacheServiceProtocol
    
    let songRepository: SongRepositoryProtocol
    let playlistRepository: PlaylistRepositoryProtocol
    
    let searchSongUseCase: SearchSongUseCaseImpl
    let getPlaylistUseCase: GetPlaylistUseCaseImpl
    let savePlaylistUseCase: SavePlaylistUseCaseImpl
    let getDetailPlaylistUseCase: GetDetailPlaylistUseCaseImpl
    
    init(factory: DIContainerFactory) {
        self.factory = factory
        
        // Initialize services with explicit dependencies
        self.networkService = factory.makeNetworkService()
        self.cacheService = factory.makeCacheService()
        
        // Initialize repositories
        self.songRepository = factory.makeSongRepository(networkService: networkService)
        self.playlistRepository = factory.makePlaylistRepository(cacheService: cacheService)
        
        // Initialize use cases
        self.searchSongUseCase = SearchSongUseCaseImpl(repository: songRepository)
        self.getPlaylistUseCase = GetPlaylistUseCaseImpl(repository: playlistRepository)
        self.savePlaylistUseCase = SavePlaylistUseCaseImpl(repository: playlistRepository)
        self.getDetailPlaylistUseCase = GetDetailPlaylistUseCaseImpl(repository: playlistRepository)
    }
}

