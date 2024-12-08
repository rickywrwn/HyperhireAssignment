//
//  SavedPlaylist.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

struct SavedPlaylist : Codable {
    let name : String?
    let uid: String?
    var music : [Results]?

}

//struct DetailPlaylist : Codable {
//    let name : String?
//    let uiid: String?
//    let music : [Results]?
//
//}
