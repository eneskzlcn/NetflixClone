//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sectionTitles : [String] = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top rated"]
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
        let heroHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = heroHeaderView
        ApiCaller.shared.getMovies(section: .topRatedMovies) { results in
            switch results {
                      case .success(let trendingTvsResponse):
                          print(trendingTvsResponse)
                      case .failure(let error):
                          print(error)
        }
        }
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
    private func getTrendingMovies() {
//        ApiCaller.shared.getTrendingMovies{ results in
//            switch results {
//            case .success(let movies):
//                print(movies[0])
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
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
//        header.textLabel?.text = header.textLabel?.text?.titleCased()
    }
}
