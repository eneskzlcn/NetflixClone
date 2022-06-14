//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private var searchResults: [Media] = []
    
    //MARK: UI Variables
    private let searchResultsTable: UITableView = {
        let table = UITableView()
        table.register(MediaCoverTableViewCell.self, forCellReuseIdentifier: MediaCoverTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search with a movie, film or type name"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    //MARK: Inherited Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(searchResultsTable)
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
    
        navigationItem.searchController = searchController
        
        fetchTopRatedMovies()
        searchController.searchResultsUpdater = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsTable.frame = view.bounds
    }
    
    //MARK: Fetch Data
    
    func fetchTopRatedMovies() {
        MediaApiManager.shared.getMedias(section: .discoverMovies) {[weak self] results in
            switch results{
            case .success(let mediaResponse):
                self?.searchResults = mediaResponse.results
                DispatchQueue.main.async {
                    self?.searchResultsTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: UI Constants
    
    struct Constants {
        static let heightForRow: CGFloat = 150
        static let heightForHeaderInSection: CGFloat = 0
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        searchResults.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeaderInSection
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCoverTableViewCell.identifier, for: indexPath) as? MediaCoverTableViewCell else {
            return UITableViewCell()
        }
        guard let posterPath = searchResults[indexPath.section].poster_path else { return cell }
        cell.setPoster(path: posterPath)

        guard let name = searchResults[indexPath.section].original_name
        else {
            guard let title = searchResults[indexPath.section].original_title else { return cell }
            cell.setMediaTitle(with: title)
            return cell
        }
        cell.setMediaTitle(with: name)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = searchResults[indexPath.section].original_name ??  searchResults[indexPath.section].original_title else {
            print("There is no title there.")
            return
        }
        let overview = searchResults[indexPath.section].overview ?? ""
        YoutubeApiManager.shared.searchMediaContent(with: title+" trailer") {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                  case .success(let youtubeVideoElement):
                      let viewModel = MediaDetailViewModel(title: title, youtubeView: youtubeVideoElement, overview: overview)
                      let viewController = MediaDetailViewController()
                      viewController.configure(with: viewModel)
                      self?.navigationController?.pushViewController(viewController, animated: true)
                  case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
            query.trimmingCharacters(in: .whitespaces).count > 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.delegate = self
        MediaApiManager.shared.search(for: query) { result in
            switch result {
            case .success(let mediaResponse):
                resultsController.searchResults = mediaResponse.results
                DispatchQueue.main.async {
                    resultsController.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(viewModel: MediaDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let mediaDetailViewController = MediaDetailViewController()
            mediaDetailViewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(mediaDetailViewController, animated: true)
        }
    }
}
