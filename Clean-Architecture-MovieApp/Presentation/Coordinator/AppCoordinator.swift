//
//  AppCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/22/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        window?.rootViewController = tabBarCoordinator.tabBarController
    }
}
