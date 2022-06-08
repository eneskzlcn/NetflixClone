//
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
        table.register(UpcomingMediaTableViewCell.self, forCellReuseIdentifier: UpcomingMediaTableViewCell.identifier)
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
        ApiCaller.shared.getMedias(section: .upcomingMovies) {[weak self] results in
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
        static let cellHeight: CGFloat = 150
    }
}

extension UpComingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMediaTableViewCell.identifier, for: indexPath)
                as? UpcomingMediaTableViewCell else {
                    return UITableViewCell()
                }
        guard let posterPath = upcomingMedias[indexPath.row].poster_path else { return cell}
        cell.setPoster(path: posterPath)
        guard let mediaTitle = upcomingMedias[indexPath.row].original_title else { return cell}
        cell.setMediaTitle(with: mediaTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
}
