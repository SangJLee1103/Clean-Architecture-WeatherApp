//
//  SearchMovieTableViewCell.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/23/25.
//

import UIKit
import Then
import SnapKit

final class SearchMovieTableViewCell: UITableViewCell {
    static let identifer = "SearchMovieTableViewCell"
    
    private let posterImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray.withAlphaComponent(0.3)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private let actorsLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let reservationDateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 13, weight: .regular)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        averageStackView.addArrangedSubview(averageImgView)
        averageStackView.addArrangedSubview(averageLabel)
        
        [posterImgView, titleLabel, actorsLabel, reservationDateLabel, averageStackView].forEach {
            contentView.addSubview($0)
        }
        
        posterImgView.snp.makeConstraints {
            $0.width.equalTo(55)
            $0.height.equalTo(68)
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        averageStackView.snp.makeConstraints {
            $0.top.equalTo(posterImgView)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImgView)
            $0.leading.equalTo(posterImgView.snp.trailing).offset(10)
            $0.trailing.equalTo(averageStackView.snp.leading).offset(15)
        }
        
        actorsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(posterImgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        reservationDateLabel.snp.makeConstraints {
            $0.top.equalTo(actorsLabel.snp.bottom).offset(10)
            $0.leading.equalTo(posterImgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    func updateUI(movie: Movie) {
        titleLabel.text = movie.title
        reservationDateLabel.text = "개봉일: \(Date().formatKoreanDate(movie.releaseDate))"
        averageLabel.text = String(format: "%.1f", movie.voteAverage)
        if let url = ImageUtil.getPosterURL(path: movie.posterPath) {
            posterImgView.sd_setImage(with: url)
        }
        actorsLabel.text = "출연: 송강호, 이정재, 이병헌"
    }
}
