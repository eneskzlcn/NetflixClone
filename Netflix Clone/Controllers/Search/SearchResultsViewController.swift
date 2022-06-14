//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 11.06.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidSelect(viewModel: MediaDetailViewModel)
}

class SearchResultsViewController: UIViewController {
    
    var searchResults = [Media]()
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 15, height: 200)
        /*minimum inter item spacing manages the spaces between elements in same row. 0 means the
        elements can be adjoining with no spaces.*/
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
            for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        guard let posterPath = searchResults[indexPath.row].poster_path else { return cell }
        cell.loadPoster(for: posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = searchResults[indexPath.row].original_name ?? searchResults[indexPath.row].original_title ?? ""
        let overview = searchResults[indexPath.row].overview ?? ""
    
        YoutubeApiManager.shared.searchMediaContent(with: title + " trailer") { result in
            switch result {
            case .success(let youtubeVideoElement):
                self.delegate?.searchResultsViewControllerDidSelect(viewModel: MediaDetailViewModel(title: title, youtubeView: youtubeVideoElement, overview: overview))
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
