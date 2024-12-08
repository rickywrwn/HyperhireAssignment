//
//  PlaylistRepository.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol PlaylistRepositoryProtocol {
    func savePlaylistsToCache(name: String?, uid: String?, musicToSave: Results?) async -> Result<String, Error>
    func retrievePlaylistFromCache() async -> Result<[SavedPlaylist], CacheError>
}

class PlaylistRepositoryImpl: PlaylistRepositoryProtocol {
    private let cacheService: CacheServiceProtocol
    private let playlistsCacheKey = "cached_playlists"
    
    init(cacheService: CacheServiceProtocol) {
        self.cacheService = cacheService
    }
    
    func savePlaylistsToCache(name: String?, uid: String?, musicToSave: Results?) async -> Result<String, Error> {
        //retrieve all playlist from cache to add new music by overriding
        let savedCache = await retrievePlaylistFromCache()
        
        switch savedCache {
        case .success(let resultPlaylist):
            var playlistData = resultPlaylist
            
//            print("success retrieve playlist (from save)", resultPlaylist)
            
            if let uniqueId = uid, let music = musicToSave{
                //if unique ID is provided, meaning playlist is exist on cache
                //modify the cache to add new song
                
                if let index = playlistData.firstIndex(where: { $0.uid == uniqueId }) {
                    playlistData[index].music?.append(music)
                } else {
                    print("Playlist with uid \(uid ?? "") not found.")
                }
            }else{
                //if unique ID is not provided, meaning it's new playlist
                //save new playlist
                playlistData = [SavedPlaylist(name: name, uid: generateUniqueCacheKey(), music: [])]
            }
            
            do {
                
                try cacheService.save(playlistData, forKey: playlistsCacheKey)
                return .success("Success saving cache")
            }catch {
                print("saving cache error: \(error.localizedDescription)")
                return .failure(error)
            }
            
        case .failure(let error):
            
            if error == CacheError.cacheDataNotExist{
                //cache not exist, save new playlist data to cache
                
                do {
                    let playlistData = [SavedPlaylist(name: name, uid: generateUniqueCacheKey(), music: [])]
                    
                    try cacheService.save(playlistData, forKey: playlistsCacheKey)
                    return .success("Success saving new cache")
                }catch {
                    print("saving cache error: \(error.localizedDescription)")
                    return .failure(error)
                }
                
            }else{
                // error in cache functionality
                
                print("retrieve cache error (from save): \(error.localizedDescription)")
                return .failure(error)
            }
        }
    }
    
    func retrievePlaylistFromCache() async -> Result<[SavedPlaylist], CacheError> {
        
        do {
            if let cachedPlaylist: [SavedPlaylist] = try cacheService.retrieve(forKey: playlistsCacheKey){
                //cache exist
//                print("retrive cache success ", cachedPlaylist)
                return .success(cachedPlaylist)
            }else{
                // cache not exist
//                print("retrived cache not exist ", CacheError.cacheDataNotExist)
                return .failure(CacheError.cacheDataNotExist)
            }
        } catch {
            print("retrieve cache error: \(error.localizedDescription)")
            return .failure(CacheError.failedToGetCacheDirectory)
        }
    }
    
    private func generateUniqueCacheKey() -> String {
        return UUID().uuidString
    }

}

