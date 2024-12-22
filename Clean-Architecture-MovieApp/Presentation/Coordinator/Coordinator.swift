//
//  Coordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/22/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinator: [Coordinator] { get set }
    func start()
}
