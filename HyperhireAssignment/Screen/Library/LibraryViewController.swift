//
//  ViewController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 06/12/24.
//

import UIKit
import FloatingPanel

protocol DismissAddPlaylistPanelDelegate {
    func handleAddPlaylist()
}

class LibraryViewController: UIViewController {
    
    weak var coordinator: LibraryCoordinator?
    let viewModel: LibraryViewModelProtocol
    var fpc: FloatingPanelController!
    
    // Current view mode with UserDefaults persistence
    private(set) var currentViewMode: ViewMode {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: "ViewModePreference"){
                return ViewMode(rawValue: rawValue) ?? .list
            }else{
                return .list
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "ViewModePreference")
            configureCollectionViewLayout()
        }
    }
    
    // MARK: - Initialization
    init(viewModel: LibraryViewModelProtocol) {
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
        setupFloatingPanel()
        
        toggleStyleButton.addTarget(self, action: #selector(toggleViewMode), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
        viewModel.viewDidLoad()
    }
    
    @objc private func toggleViewMode() {
        // Toggle between list and grid
        currentViewMode = (currentViewMode == .list) ? .grid : .list
        
        if currentViewMode == .list {
            toggleStyleButton.setImage(.gridIcon, for: .normal)
        }else{
            toggleStyleButton.setImage(.listIcon, for: .normal)
        }
        
    }
    
    @objc private func handleAdd() {
        self.present(fpc, animated: true)
    }
    
    private func configureCollectionViewLayout() {
        let layout = createCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    private func setupUI() {
        
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(playlistLabel)
        view.addSubview(sortImageView)
        view.addSubview(sortLabel)
        view.addSubview(toggleStyleButton)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            profileImageView.heightAnchor.constraint(equalToConstant: 35),
            profileImageView.widthAnchor.constraint(equalToConstant: 35),
            
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            addButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            addButton.heightAnchor.constraint(equalToConstant: 26),
            addButton.widthAnchor.constraint(equalToConstant: 26),
            
            playlistLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 28),
            playlistLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            playlistLabel.heightAnchor.constraint(equalToConstant: 33),
            playlistLabel.widthAnchor.constraint(equalToConstant: 83),
            
            sortImageView.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: 28),
            sortImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            sortImageView.heightAnchor.constraint(equalToConstant: 10),
            sortImageView.widthAnchor.constraint(equalToConstant: 15),
            
            sortLabel.centerYAnchor.constraint(equalTo: sortImageView.centerYAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: sortImageView.trailingAnchor, constant: 12),
            
            toggleStyleButton.topAnchor.constraint(equalTo: sortImageView.topAnchor),
            toggleStyleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            toggleStyleButton.heightAnchor.constraint(equalToConstant: 15),
            toggleStyleButton.widthAnchor.constraint(equalToConstant: 15),
            
            collectionView.topAnchor.constraint(equalTo: toggleStyleButton.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 17.5
        imageView.image = ImageManager.image(for: .profilePicture)
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .bold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Library"
        return label
    }()
    
    private var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageManager.image(for: .addIcon), for: .normal)
        return button
    }()
    
    private var playlistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .regular, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Playlists"
        label.layer.cornerRadius = 16.5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.playlistBorderColor.cgColor
        label.textAlignment = .center
        return label
    }()
    
    private var toggleStyleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ImageManager.image(for: .gridIcon), for: .normal)
        return button
    }()
    
    private var sortImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = ImageManager.image(for: .sortIcon)
        return imageView
    }()
    
    private var sortLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .regular, size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most recent"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ListLibraryCollectionViewCell.self, forCellWithReuseIdentifier: ListLibraryCollectionViewCell.identifier)
        collectionView.register(GridLibraryCollectionViewCell.self, forCellWithReuseIdentifier: GridLibraryCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

}


extension LibraryViewController: DismissAddPlaylistPanelDelegate{
    
    func handleAddPlaylist() {
        coordinator?.showAddPlaylist()
    }
    
}
