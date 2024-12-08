//
//  DetailPlaylistViewController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

class DetailPlaylistViewController: UIViewController {
    
    weak var coordinator: PlaylistCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientBG()
        setupUI()
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
    }
    
    @objc private func handleBack() {
        coordinator?.popViewController()
    }
    
    @objc private func handleAdd() {
        coordinator?.showSongList()
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(addButton)
        view.addSubview(titleLabel)
        view.addSubview(songLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            addButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            songLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            songLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createGradientBG(){
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.topGradientColor.cgColor,
            UIColor.backgroundColor.cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.2]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .bold, size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My First Library"
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var songLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryTextColor
        label.font = .AvenirNext(type: .bold, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 songs"
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageManager.image(for: .addIcon), for: .normal)
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageManager.image(for: .backIcon), for: .normal)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(DetailPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: DetailPlaylistCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    

    func createCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: createListSection())
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .uniformAcrossSiblings(estimate: 70.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 0
        
        return section
    }
    
}

extension DetailPlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailPlaylistCollectionViewCell.identifier,
            for: indexPath
        ) as? DetailPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

