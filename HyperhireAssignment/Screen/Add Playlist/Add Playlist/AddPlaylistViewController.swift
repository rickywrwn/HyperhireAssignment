//
//  AddPlaylistViewController.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

class AddPlaylistViewController: UIViewController {
    
    weak var coordinator: PlaylistCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondaryBackgroundColor
        setupUI()
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
    
    @objc private func handleConfirm(){
        coordinator?.dismissViewController()
        coordinator?.showDetailPlaylist()
    }
    
    private func setupUI() {
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(lineView)
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            lineView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 2),
            lineView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: -3),
            lineView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 3),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            confirmButton.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
            confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.font = .AvenirNext(type: .bold, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name Your Playlist."
        return label
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .confirmButtonColor
        button.setTitle("Confirm", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        button.titleLabel?.font = .AvenirNext(type: .bold, size: 20)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .AvenirNext(type: .bold, size: 24)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .primaryTextColor
        return textField
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
}
