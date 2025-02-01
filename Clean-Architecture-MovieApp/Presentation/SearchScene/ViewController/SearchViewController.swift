//
//  SearchViewController.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import UIKit
import Then
import SnapKit

import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    weak var coordinator: SearchCoordinator?
    
    let movie = Movie(
        title: "핌피네로: 블러드 앤드 오일",
        overview: "콜롬비아와 베네수엘라 국경에 자리한 사막. '핌피네로'는 이곳을 통해 양국을 오가며 불법으로 휘발유를 배달한다. 젊은 기름 밀수꾼 후안은 어쩔 수 없이 비밀스러운 라이벌 밑에서 일하게 되고, 후안의 여자 친구 디아나는 무인 지대에 감춰진 비밀을 파헤치기 위해 위험한 여행길에 오른다.",
        backdropPath: "/r4Xn4eWOyxye8m3dR80I8TPhfE5.jpg",
        posterPath: "/kukotsflOSVGXQezuXohj41dbfL.jpg",
        voteAverage: 7.0,
        releaseDate: "2024-10-10"
    )
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.delegate = self
        $0.dataSource = self
        $0.register(SearchMovieTableViewCell.self, forCellReuseIdentifier: SearchMovieTableViewCell.identifer)
    }
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        title = "영화검색"
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func bind() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map {  }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieTableViewCell.identifer, for: indexPath) as! SearchMovieTableViewCell
        cell.updateUI(movie: movie)
        return cell
    }
}
