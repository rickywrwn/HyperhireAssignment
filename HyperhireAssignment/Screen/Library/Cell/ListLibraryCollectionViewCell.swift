//
//  ListLibraryCollectionViewCell.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

final class ListLibraryCollectionViewCell: UICollectionViewCell {
    static let identifier = "ListLibraryCollectionViewCell"
    
    private lazy var imageView: DynamicImageView = {
        let imageView = DynamicImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .searchTextFieldColor
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.text = "My first library"
        label.font = .AvenirNext(type: .bold, size: 15)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryTextColor
        label.text = "subtitle"
        label.font = .AvenirNext(type: .regular, size: 13)
        label.text = "Playlist • 58 Songs"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.imageURLs.removeAll()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with playlist: SavedPlaylist){

        if let music = playlist.music, music.count > 0{
            let topFour = Array(music.prefix(4))
            
            imageView.imageURLs = topFour.compactMap {
                guard let urlString = $0.artworkUrl100, let url = URL(string: urlString) else {
                    return nil
                }
                return url
            }

        }
    
        titleLabel.text = playlist.name
        
        if let musicCount = playlist.music?.count{
            subtitleLabel.text = "Playlist • \(musicCount) Songs"
        }
    }
    
    private func setupUI() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 67),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            subtitleLabel.topAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
        ])
    }
}

