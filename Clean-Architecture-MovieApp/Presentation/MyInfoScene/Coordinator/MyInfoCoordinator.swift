//
//  MyInfoCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import UIKit

final class MyInfoCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = MyInfoViewController()
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }
}
