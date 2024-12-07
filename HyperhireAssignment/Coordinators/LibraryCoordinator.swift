//
//  LibraryCoordinator.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

//import UIKit
import SwiftUI

class LibraryCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        setupNavigationBar()
    }
    
    func start() {
        showLibraryView()
    }
    
    private func showLibraryView() {
        let viewController = LibraryViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
//    private func setupNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .clear
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.channelNavigationTextColor]
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.channelNavigationTextColor]
//        
//        navigationController.navigationBar.standardAppearance = appearance
//        navigationController.navigationBar.scrollEdgeAppearance = appearance
//        navigationController.navigationBar.compactAppearance = appearance
//        
//        navigationController.navigationBar.tintColor = .white
//    }
}


