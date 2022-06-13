//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 8.06.2022.
//

import UIKit
import SDWebImage


class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    public func loadPoster(for path: String) {
        guard let url = URL(string: MediaApiManager.shared.posterUrl(for: path)) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
