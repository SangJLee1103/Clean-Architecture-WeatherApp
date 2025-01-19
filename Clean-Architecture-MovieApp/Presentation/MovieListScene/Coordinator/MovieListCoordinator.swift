//
//  MovieListCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/22/24.
//

import UIKit

final class MovieListCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MovieListViewModel(
            movieListUseCase: DefaultMovieUseCase(
                repository: DefaultMovieRepository(
                    movieService: MovieService()
                )
            )
        )
        let viewController = MovieListViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showMovieDetail(with movie: Movie) {
        let movieDetailCoordinator = MovieDetailCoordinator(
            navigationController: navigationController,
            movie: movie
        )
        childCoordinators.append(movieDetailCoordinator)
        movieDetailCoordinator.parentCoordinator = self
        movieDetailCoordinator.start()
    }
}
