//
//  CacheService.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

// MARK: - Cache Protocol
protocol CacheServiceProtocol {
    func save<T: Encodable>(_ object: T, forKey key: String) throws
    func retrieve<T: Decodable>(forKey key: String) throws -> T?
    func removeObject(forKey key: String)
    func clear()
}

// MARK: - Disk Cache Implementation
class CacheService: CacheServiceProtocol {
    private let fileManager: FileManager
    private let cacheDirectory: URL
    
    init() throws {
        self.fileManager = FileManager.default
        
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw CacheError.failedToGetCacheDirectory
        }
        
        self.cacheDirectory = cacheDir.appendingPathComponent("AppCache")
        try createDirectoryIfNeeded()
    }
    
    private func createDirectoryIfNeeded() throws {
        guard !fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func save<T: Encodable>(_ object: T, forKey key: String) throws {
        print("saved to cache: ", key)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL)
    }
    
    func retrieve<T: Decodable>(forKey key: String) throws -> T? {
        print("retrieved from cache: ", key)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func removeObject(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clear() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? createDirectoryIfNeeded()
        print("Cache cleared")
    }
}
