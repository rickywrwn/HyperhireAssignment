//
//  SongListViewController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit
import Combine

class SongListViewController: UIViewController, UISearchBarDelegate{
    
    weak var coordinator: PlaylistCoordinator?
    let viewModel: SongListViewModelProtocol
    
    // PassthroughSubject to send search queries
    private var searchSubject = PassthroughSubject<String, Never>()
    
    // Cancellable for Combine subscription
    private var cancellables = Set<AnyCancellable>()
  
    
    // MARK: - Initialization
    init(viewModel: SongListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupUI()
        setupBindings()
        setupSearchDebounce()
        
        searchTextField.delegate = self
        Task {
            await viewModel.fetchSong(search: "justin bieber")
        }
    }
    
    private func setupSearchDebounce() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // 300ms debounce
            .removeDuplicates()  // Only unique values
            .sink { [weak self] searchText in
                Task {
                    await self?.viewModel.fetchSong(search: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        
        viewModel.onMusicDataChanged = { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSubject.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked: \(searchBar.text ?? "")")
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchBar.resignFirstResponder()
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            searchTextField.heightAnchor.constraint(equalToConstant: 35),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private var searchTextField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font = UIFont.AvenirNext(type: .bold, size: 15)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .backgroundColor
        searchBar.tintColor = .white
        searchBar.layer.cornerRadius = 10
        searchBar.showsCancelButton = true
        
        // Customize the search icon
        let iconImage = ImageManager.image(for: .searchIcon)
        let imageView = UIImageView(image: iconImage)
        searchBar.searchTextField.leftView = imageView
        searchBar.searchTextField.textColor = .primaryTextColor
        
        // Customize the cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [.font: UIFont.AvenirNext(type: .bold, size: 15)!, .foregroundColor: UIColor.white],
            for: .normal
        )
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(SongListCollectionViewCell.self, forCellWithReuseIdentifier: SongListCollectionViewCell.identifier)
        
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
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

extension SongListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SongListCollectionViewCell.identifier,
            for: indexPath
        ) as? SongListCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let music = viewModel.musicData, indexPath.row < music.count{
            cell.configure(with: music[indexPath.row])
        }
        return cell
    }
}
