//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 27.05.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let home = UINavigationController(rootViewController: HomeViewController())
        let upcoming = UINavigationController(rootViewController: UpComingViewController())
        let search = UINavigationController(rootViewController: SearchViewController())
        let downloads = UINavigationController(rootViewController: DownloadsViewController())
        
        home.tabBarItem.image = UIImage(systemName: "house")
        home.title = "Home"
        
        upcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        upcoming.title = "Coming Soon"
        
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        search.title = "Top Searches"
        
        downloads.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloads.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([home, upcoming, search, downloads], animated: true)
    }
}

