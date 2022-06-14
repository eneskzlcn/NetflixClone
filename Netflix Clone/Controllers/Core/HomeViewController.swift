//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sectionTitles: [MediaSection: String] = [
        .trendingMovies:"Trending Movies",.trendingTvs: "Trending Tv",.popularMovies: "Popular",.upcomingMovies: "Upcoming Movies",.topRatedMovies: "Top Rated"]
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        configureHeroHeaderView()
    }
    private func configureHeroHeaderView() {
        let heroHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        MediaApiManager.shared.getMedias(section: .trendingMovies) { result in
            switch result {
            case .success(let mediaResponse):
                guard let randomMedia = mediaResponse.results.randomElement(),
                      let posterPath = randomMedia.poster_path else { return }
                heroHeaderView.loadHeroImage(from: posterPath)
            case .failure(let error):
                print(error)
            }
        }
        
        homeFeedTable.tableHeaderView = heroHeaderView
    }
    private func configureNavbar() {
        var image = UIImage(named: "netflix-logo-big.png")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[MediaSection(rawValue: section)!]

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        guard let section = MediaSection(rawValue: indexPath.section) else { return cell }
        MediaApiManager.shared.getMedias(section: section) { results in
            switch results {
            case .success(let mediaResponse):
                cell.setMedias(with: mediaResponse.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = UIFont(name: "Tiro Devanagari Sanskrit Regular", size: 15)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.frame.height)
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MediaDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            let mediaDetailViewController = MediaDetailViewController()
            mediaDetailViewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(mediaDetailViewController, animated: true)
        }
    }
}
