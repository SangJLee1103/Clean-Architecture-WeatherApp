//
//  MovieListTitleHeaderView.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/15/24.
//

import UIKit
import SnapKit
import Then

final class MovieListTitleHeaderView: UICollectionReusableView {
    static let identifier = "MovieListTitleHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func updateUI(title: String) {
        titleLabel.text = title
    }
}
