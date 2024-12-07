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
    }
    
    func start() {
        let viewController = LibraryViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}


