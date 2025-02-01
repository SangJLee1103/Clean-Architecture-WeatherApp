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
        let homeNavigationController = UINavigationController()
        let movieListCoordinator = MovieListCoordinator(navigationController: homeNavigationController)
        childCoordinators.append(movieListCoordinator)
        movieListCoordinator.start()
        
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        
        let searchNavigationController = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let myInfoNavigationController = UINavigationController()
        let myInfoCoordinator = MyInfoCoordinator(navigationController: myInfoNavigationController)
        childCoordinators.append(myInfoCoordinator)
        myInfoCoordinator.start()
        
        myInfoNavigationController.tabBarItem = UITabBarItem(
            title: "내정보",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBarController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            myInfoNavigationController
        ]
    }
}
