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
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
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
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(SearchMovieTableViewCell.self, forCellReuseIdentifier: SearchMovieTableViewCell.identifer)
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        bind()
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
        let input = SearchViewModel.Input(
            movieText: searchController.searchBar.rx.text.orEmpty.asObservable(),
            loadNextPage: tableView.rx.reachedBottom.asObservable(),
            searchControllerIsActive: searchController.rx.isActive
        )
        
        let output = viewModel.transform(input: input)
        
        output.movies
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchMovieTableViewCell.identifer,
                cellType: SearchMovieTableViewCell.self
            )) { _, movie, cell in
                cell.updateUI(movie: movie)
            }
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                // TODO: MovieDetail로 PushVC
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .filter { [weak self] in
                self?.tableView.isDragging == true
            }
            .subscribe(onNext: { [weak self] _ in
                self?.searchController.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UITableView {
    var reachedBottom: ControlEvent<Void> {
        let source = self.contentOffset.map { [weak base] contentOffset in
            guard let base = base else { return false }
            
            let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
            let y = contentOffset.y + base.contentInset.top
            let threshold = max(0.0, base.contentSize.height - visibleHeight)
            
            return y > threshold - 100
        }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UISearchController {
    var isActive: Observable<Bool> {
        return self.observe(Bool.self, #keyPath(UISearchController.isActive))
            .compactMap { $0 }
    }
}
