//
//  ErrorView.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import UIKit

class ErrorView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        // Use system image for error
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        addSubview(stackView)
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(okButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            errorImageView.heightAnchor.constraint(equalToConstant: 50),
            errorImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    func configure(with error: Error) {
        errorLabel.text = error.localizedDescription
    }
    
    @objc private func okTapped() {
        self.isHidden = true
    }
}
