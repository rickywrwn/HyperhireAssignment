//
//  MusicListSelectedDelegate.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

protocol MusicListSelectedDelegate {
    func handleAddMusic(with music: Results)
}

extension DetailPlaylistViewController: MusicListSelectedDelegate{
    
    func handleAddMusic(with music: Results) {
        viewModel.saveMusicToPlaylist(withMusic: music)
    }
    
}
