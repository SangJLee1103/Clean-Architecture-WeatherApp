//
//  MovieListViewController.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import UIKit
import SnapKit
import Then

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
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
        $0.dataSource = self
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
        section.orthogonalScrollingBehavior = .groupPaging
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionVIewDataSource
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieListTitleHeaderView.identifier, for: indexPath) as? MovieListTitleHeaderView,
              let section = Section(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        headerView.updateUI(title: section.title)
        return headerView
    }
}
