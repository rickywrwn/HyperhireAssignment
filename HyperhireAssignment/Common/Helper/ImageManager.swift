//
//  ImageManager.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

import UIKit

struct ImageManager {
    enum ImageAsset: String {
        case addIcon = "add_icon"
        case profilePicture = "profile_picture"
        case gridIcon = "grid_icon"
        case listIcon = "list_icon"
        case sortIcon = "sort_icon"
        case homeIcon = "home_icon"
        case searchIcon = "search_icon"
        case libraryIcon = "library_icon"
        case addPlaylistIcon = "add_playlist_icon"
        case backIcon = "back_icon"
        case optionIcon = "option_icon"
        case imagePlaceholder = "image_placeholder"
    }

    static func image(for imageAsset: ImageAsset) -> UIImage? {
        return UIImage(named: imageAsset.rawValue)
    }
}
