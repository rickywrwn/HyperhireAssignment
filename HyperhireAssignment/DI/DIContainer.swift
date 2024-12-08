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
//    let episodeRepository: EpisodeRepositoryProtocol
//    let categoryRepository: CategoryRepositoryProtocol
//    
    let searchSongUseCase: SearchSongUseCaseImpl
//    let newEpisodeUseCase: NewEpisodeUseCaseProtocol
//    let categoryUseCase: CategoryUseCaseProtocol
    
    init(factory: DIContainerFactory) {
        self.factory = factory
        
        // Initialize services with explicit dependencies
        self.networkService = factory.makeNetworkService()
        self.cacheService = factory.makeCacheService()
        
        // Initialize repositories
        self.songRepository = factory.makeSongRepository(networkService: networkService, cacheService: cacheService)
//        self.episodeRepository = factory.makeEpisodeRepository(networkService: networkService, cacheService: cacheService)
//        self.categoryRepository = factory.makeCategoryRepository(networkService: networkService, cacheService: cacheService)
//        
//        // Initialize use cases
        self.searchSongUseCase = SearchSongUseCaseImpl(repository: songRepository)
//        self.newEpisodeUseCase = NewEpisodeUseCaseImpl(
//            repository: episodeRepository
//        )
//        self.categoryUseCase = CategoryUseCaseImpl(repository: categoryRepository)
    }
}

