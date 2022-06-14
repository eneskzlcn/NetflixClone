//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MediaDetailViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    private var medias: [Media] = []
    
    weak var delegate: CollectionViewTableViewCellDelegate?
        
    private let collectionView : UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize =   CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)

        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemOrange
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func setMedias(with medias: [Media]) {
        self.medias = medias
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let posterPath = medias[indexPath.row].poster_path else { return cell }
        cell.loadPoster(for: posterPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let media = medias[indexPath.row]
        
        guard let mediaName = media.original_name ?? media.original_title else { return }
        
        YoutubeApiManager.shared.searchMediaContent(with: mediaName + " trailer") {[weak self] result in
            switch result {
            case .success(let videoElement):
                print(videoElement)
                guard let title = self?.medias[indexPath.row].original_name ??  self?.medias[indexPath.row].original_title else { return }
                guard let strongSelf = self else { return }
                let viewModel = MediaDetailViewModel(title: title, youtubeView: videoElement, overview: self?.medias[indexPath.row].overview ?? "")
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
