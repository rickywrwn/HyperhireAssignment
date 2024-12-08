//
//  SongListViewController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit
import Combine

class SongListViewController: UIViewController{
    
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
        setupLoadingView()
        setupErrorView()
        
        searchTextField.delegate = self
        
    }
    
    private func showErrorView(with error: Error) {
        stopLoading()
        errorView.alpha = 0
        errorView.isHidden = false
        errorView.configure(with: error)
        
        UIView.animate(withDuration: 0.3) {
            self.errorView.alpha = 1
        }
    }
    
    private func startLoading() {
        loadingView.alpha = 0
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.loadingView.alpha = 1
        }
    }
    
    private func stopLoading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
        }, completion: { _ in
            self.loadingView.stopAnimating()
            self.loadingView.isHidden = true
        })
    }
    
    private func setupSearchDebounce() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 500ms debounce
            .removeDuplicates()  // Only unique values
            .sink { [weak self] searchText in
                Task {
                    self?.startLoading()
                    await self?.viewModel.fetchSong(search: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        
        viewModel.onMusicDataChanged = { [weak self] in
            self?.collectionView.reloadData()
            self?.stopLoading()
        }
        
        viewModel.onErrorDataChanged = { [weak self] in
            self?.showErrorView(with: self?.viewModel.errorData ?? NetworkError.custom("Something's Wrong"))
        }
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupErrorView() {
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var searchTextField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font = .AvenirNext(type: .bold, size: 15)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .backgroundColor
        searchBar.tintColor = .white
        searchBar.layer.cornerRadius = 10
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .search
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
    
}

extension SongListViewController, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSubject.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await viewModel.fetchSong(search: searchBar.text ?? "")
        }
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        coordinator?.popViewController()
    }
}
