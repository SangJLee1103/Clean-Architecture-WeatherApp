//
//  UIImageView+Rx.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

extension Reactive where Base: UIImageView {
    var imagePath: Binder<String> {
        return Binder(base) { imageView, path in
            if let url = ImageUtil.getPosterURL(path: path) {
                imageView.sd_setImage(with: url)
            }
        }
    }
}
