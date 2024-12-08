//
//  LibraryViewController+CollectionView.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

extension LibraryViewController {
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            
            switch self?.currentViewMode {
            case .list:
                return self?.createListSection()
            case .grid:
                return self?.createGridSection()
            case .none:
                return self?.createListSection()
            }
        }
        return layout
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .uniformAcrossSiblings(estimate: 84.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 0
        
        return section
    }
        
    private func createGridSection() -> NSCollectionLayoutSection {
        // Item
        let screenWidth = UIScreen.main.bounds.width
        let totalMargins: CGFloat = 36 // (leading 18 + trailing 18)
        let interItemSpacing: CGFloat = 18
        let availableWidth = screenWidth - totalMargins - interItemSpacing
        let itemWidth = availableWidth / 2
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .uniformAcrossSiblings(estimate: 226.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(18)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18)
        section.interGroupSpacing = 0
        
        return section
    }
}

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlistData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch currentViewMode {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListLibraryCollectionViewCell.identifier,
                for: indexPath
            ) as? ListLibraryCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let playlist = viewModel.playlistData?[indexPath.row] {
                cell.configure(with: playlist)
            }
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridLibraryCollectionViewCell.identifier,
                for: indexPath
            ) as? GridLibraryCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let playlist = viewModel.playlistData?[indexPath.row] {
                cell.configure(with: playlist)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlist = viewModel.playlistData?[indexPath.row] {
            coordinator?.showDetailPlaylist(with: playlist.uid ?? "")
        }
    }
}
