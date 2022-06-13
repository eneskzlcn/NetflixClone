//  UpComingViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

class UpComingViewController: UIViewController {

    private var upcomingMedias: [Media] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MediaCoverTableViewCell.self, forCellReuseIdentifier: MediaCoverTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    public func fetchData() {
        MediaApiManager.shared.getMedias(section: .upcomingMovies) {[weak self] results in
            switch results{
            case .success(let mediaResponse):
                self?.upcomingMedias = mediaResponse.results
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    struct Constants {
        static let heightForRow: CGFloat = 150
        static let heightForHeaderInSection: CGFloat = 0.5
    }
}

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        self.upcomingMedias.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaCoverTableViewCell.identifier, for: indexPath)
                as? MediaCoverTableViewCell else { return UITableViewCell() }
        guard let posterPath = upcomingMedias[indexPath.section].poster_path else { return cell }
        cell.setPoster(path: posterPath)
        guard let mediaTitle = upcomingMedias[indexPath.section].original_title else { return cell }
        cell.setMediaTitle(with: mediaTitle)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.heightForHeaderInSection
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
    
    
}
