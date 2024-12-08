//
//  AddPlaylistPanel.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

final class AddPlaylistPanel: UIViewController {
    
    var delegate: DismissAddPlaylistPanelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondaryBackgroundColor
        setupUI()
        
        viewButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
    }
    
    @objc private func handleAdd(){
        self.dismiss(animated: true)
        delegate?.handleAddPlaylist()
    }
    
    func setupUI(){
        
        view.addSubview(containerPlaylistView)
        containerPlaylistView.addSubview(imageView)
        containerPlaylistView.addSubview(playlistLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(viewButton)
        
        NSLayoutConstraint.activate([
            
            containerPlaylistView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            containerPlaylistView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            containerPlaylistView.heightAnchor.constraint(equalToConstant: 45),
            containerPlaylistView.widthAnchor.constraint(equalToConstant: 45),
            
            imageView.topAnchor.constraint(equalTo: containerPlaylistView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerPlaylistView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            
            playlistLabel.centerXAnchor.constraint(equalTo: containerPlaylistView.centerXAnchor),
            playlistLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            
            titleLabel.bottomAnchor.constraint(equalTo: containerPlaylistView.centerYAnchor, constant: -2),
            titleLabel.leadingAnchor.constraint(equalTo: containerPlaylistView.trailingAnchor, constant: 15),
            
            subtitleLabel.topAnchor.constraint(equalTo: containerPlaylistView.centerYAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerPlaylistView.trailingAnchor, constant: 15),
            
            viewButton.topAnchor.constraint(equalTo: containerPlaylistView.topAnchor),
            viewButton.leadingAnchor.constraint(equalTo: containerPlaylistView.leadingAnchor),
            viewButton.bottomAnchor.constraint(equalTo: containerPlaylistView.bottomAnchor),
            viewButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private var containerPlaylistView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = ImageManager.image(for: .addPlaylistIcon)
        return imageView
    }()
    
    private var playlistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryTextColor
        label.font = .AvenirNext(type: .light, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Playlist"
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .bold, size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Playlist"
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryTextColor
        label.font = .AvenirNext(type: .bold, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create a playlist with a song"
        return label
    }()
    
    private var viewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
