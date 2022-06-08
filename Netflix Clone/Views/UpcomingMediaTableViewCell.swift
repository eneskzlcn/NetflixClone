//
//  UpcomingMediaTableViewCell.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 8.06.2022.
//

import UIKit
import SDWebImage

class UpcomingMediaTableViewCell: UITableViewCell {
    
    // MARK: Variables
    static let identifier = "UpcomingMediaTableViewCell"
   
    // MARK: UI Variables
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    private let mediaTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Tiro Devanagari Sanskrit Regular", size: 15)
        return label
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: Applying Constraints To UI Elements
    private func applyConstraints() {
        let mediaTitleConstraints = [
            mediaTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mediaTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mediaTitle.widthAnchor.constraint(equalToConstant: 150)
        ]
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(mediaTitleConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    // MARK: Overrided Inherited Functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(mediaTitle)
        contentView.addSubview(playButton)
        applyConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    public func setPoster(path posterPath: String) {
        guard let url = URL(string: ApiCaller.shared.posterUrl(for: posterPath)) else { return }
        imageView?.sd_setImage(with: url, completed: nil)
    }
    public func setMediaTitle(with title: String) {
        mediaTitle.text = title
    }
}
