//
//  SongListSelectedDelegate.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol SongListSelectedDelegate {
    func handleAddSong()
}

extension DetailPlaylistViewController: SongListSelectedDelegate{
    
    func handleAddMusic(with music: Results) {
        
    }
    
}
