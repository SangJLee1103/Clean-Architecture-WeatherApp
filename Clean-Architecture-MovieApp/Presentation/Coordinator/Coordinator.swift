//
//  Coordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/22/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol TabBarCoordinating: Coordinator {
    var tabBarController: UITabBarController { get }
}

protocol NavigationCoordinating: Coordinator {
    var navigationController: UINavigationController { get }
}
