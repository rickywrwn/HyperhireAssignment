//
//  SongListCollectionViewCell.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit
import Kingfisher

final class SongListCollectionViewCell: UICollectionViewCell {
    static let identifier = "SongListCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with music: Results){
        
        if let imageUrlString = music.artworkUrl60, let imageUrl = URL(string: imageUrlString) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2)), .cacheOriginalImage])
        } else {
            imageView.image = ImageManager.image(for: .imagePlaceholder)
        }
    
        titleLabel.text = music.trackName
        subtitleLabel.text = music.artistName
    }
    
    private func setupUI() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -3),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            subtitleLabel.topAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 3),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
        ])
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .searchTextFieldColor
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .bold, size: 14)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryTextColor
        label.font = .AvenirNext(type: .regular, size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}



