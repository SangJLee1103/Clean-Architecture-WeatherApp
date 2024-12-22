//
//  AppCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/22/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMovieList()
    }
    
    private func showMovieList() {
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        childCoordinator.append(movieListCoordinator)
        movieListCoordinator.start()
    }
}
