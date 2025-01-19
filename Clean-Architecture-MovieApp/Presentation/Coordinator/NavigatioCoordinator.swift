//
//  NavigatioNCoordinator.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import UIKit

protocol NavigatioCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}
