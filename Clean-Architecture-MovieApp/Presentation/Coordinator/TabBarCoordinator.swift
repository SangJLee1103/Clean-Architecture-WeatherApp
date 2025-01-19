//
//  TabBarCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import UIKit

final class TabBarCoordinator: TabBarCoordinating {
    var childCoordinators: [Coordinator] = []
    let tabBarController : UITabBarController
    
    init() {
        self.tabBarController = UITabBarController()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBarController.tabBar.tintColor = .white
    }
    
    func start() {
        let navigationController = UINavigationController()
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        childCoordinators.append(movieListCoordinator)
        movieListCoordinator.start()
        
        navigationController.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        tabBarController.viewControllers = [navigationController]
    }
}
