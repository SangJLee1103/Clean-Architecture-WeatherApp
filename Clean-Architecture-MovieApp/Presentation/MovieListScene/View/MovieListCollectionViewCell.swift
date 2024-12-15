//
//  MovieListCollectionViewCell.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/15/24.
//

import UIKit
import SnapKit
import Then
import SDWebImage

final class MovieListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCollectionViewCell"
    
    private let posterImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray.withAlphaComponent(0.3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(posterImgView)
        posterImgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI(posterPath: String) {
        posterImgView.sd_setImage(with: URL(string: posterPath))
    }
}
