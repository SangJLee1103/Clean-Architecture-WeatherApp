//
//  MyInfoViewController.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import UIKit

final class MyInfoViewController: UIViewController {
    weak var coordinator: MyInfoCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
    }
}

