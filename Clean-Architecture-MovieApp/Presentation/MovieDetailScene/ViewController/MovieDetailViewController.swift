//
//  MovieDetailViewController.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SDWebImage

final class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray.withAlphaComponent(0.3)
        $0.clipsToBounds = true
    }
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)).then {
        $0.alpha = 0.6
    }
    
    private let posterImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray.withAlphaComponent(0.3)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .right
    }
    
    private let averageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let averageImgView = UIImageView().then {
        $0.image = UIImage(systemName: "star.fill")
        $0.tintColor = .systemYellow
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { $0.size.equalTo(18) }
    }
    
    private let averageLabel = UILabel().then {
        $0.textColor = .systemYellow
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let overviewLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        averageStackView.addArrangedSubview(averageImgView)
        averageStackView.addArrangedSubview(averageLabel)
        
        [backgroundImgView, blurEffectView, posterImgView, titleLabel, releaseDateLabel, averageStackView, overviewLabel]
            .forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        backgroundImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(backgroundImgView.snp.width).multipliedBy(3.0/4.0)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(blurEffectView.snp.width).multipliedBy(3.0/4.0)
        }
        
        posterImgView.snp.makeConstraints {
            $0.centerY.equalTo(backgroundImgView.snp.bottom)
            $0.leading.equalTo(safeArea).offset(20)
            $0.width.equalTo(view.snp.width).multipliedBy(0.4)
            $0.height.equalTo(posterImgView.snp.width).multipliedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImgView.snp.bottom).offset(20)
            $0.leading.equalTo(safeArea).offset(20)
            $0.trailing.equalTo(releaseDateLabel.snp.leading).offset(-20).priority(.high)
        }
        
        averageStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(safeArea).offset(20)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(safeArea).inset(20)
            $0.width.greaterThanOrEqualTo(140)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(averageStackView.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(safeArea).inset(20)
            $0.bottom.lessThanOrEqualTo(safeArea).inset(20)
        }
    }
    
    private func bind() {
        let output = viewModel.trasform(input: .init(
            viewDidLoadEvent: Observable.just(())
        ))
        
        output.backdropPath
            .drive(backgroundImgView.rx.imagePath)
            .disposed(by: disposeBag)
        
        output.posterPath
            .drive(posterImgView.rx.imagePath)
            .disposed(by: disposeBag)
        
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.releaseDate
            .drive(releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.average
            .drive(averageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.overview
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
