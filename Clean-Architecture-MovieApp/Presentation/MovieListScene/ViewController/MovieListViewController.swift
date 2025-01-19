//
//  MovieListViewController.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

enum Section: Int, CaseIterable {
    case popular
    case nowPlaying
    case topRated
    case upcoming
    
    var title: String {
        switch self {
        case .popular:
            "지금 뜨는 컨텐츠"
        case .nowPlaying:
            "현재 상영작"
        case .topRated:
            "평점 높은 작품"
        case .upcoming:
            "개봉 예정작"
        }
    }
}

final class MovieListViewController: UIViewController {
    weak var coordinator: MovieListCoordinator?
    private let viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()
    
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var refreshControl = UIRefreshControl().then {
        $0.tintColor = .white
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        $0.register(MovieListTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieListTitleHeaderView.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard Section(rawValue: sectionIndex) != nil else { return nil }
            return self?.createHorizontalSection()
        }
        return layout
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(55))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        bind()
    }
    
    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "SJ Movie"
        navigationItem.backButtonTitle = ""
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    private func bind() {
        let output = viewModel.trasform(input: .init(
            viewDidLoadEvent: Observable.just(()),
            pullToRefresh: refreshControl.rx.controlEvent(.valueChanged).asObservable()
        ))
        
        Observable.combineLatest(
            output.popularMovies,
            output.nowPlayingMovies,
            output.topRatedMovies,
            output.upcomingMovies
        )
        .map { popular, nowPlaying, topRated, upcoming -> [MovieSection] in
            [
                MovieSection(section: .popular, items: popular),
                MovieSection(section: .nowPlaying, items: nowPlaying),
                MovieSection(section: .topRated, items: topRated),
                MovieSection(section: .upcoming, items: upcoming)
            ]
        }
        .bind(to: collectionView.rx.items(dataSource: createDataSource()))
        .disposed(by: disposeBag)
        
        output.isLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Movie.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, movie in
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                
                owner.navigationController?.navigationBar.standardAppearance = appearance
                owner.navigationController?.navigationBar.scrollEdgeAppearance = appearance
                owner.navigationController?.navigationBar.compactAppearance = appearance
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    owner.coordinator?.showMovieDetail(with: movie)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MovieSection> {
        RxCollectionViewSectionedReloadDataSource<MovieSection>(
            configureCell: { dataSource, collectionView, indexPath, movie in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else { return UICollectionViewCell() }
                cell.updateUI(posterPath: movie.posterPath)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader,
                      let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MovieListTitleHeaderView.identifier,
                        for: indexPath
                      ) as? MovieListTitleHeaderView else {
                    return UICollectionReusableView()
                }
                let section = dataSource.sectionModels[indexPath.section].section
                header.updateUI(title: section.title)
                return header
            }
        )
    }
}
