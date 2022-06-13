//
//  Media.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 6.06.2022.
//

import Foundation


protocol NetflixMedia: Codable {}


struct MediaResponse: NetflixMedia {
    let results: [Media]
}
struct Media: NetflixMedia {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

enum MediaSection: Int {
    case trendingMovies = 0
    case trendingTvs = 1
    case popularMovies = 2
    case upcomingMovies = 3
    case topRatedMovies = 4
    case discoverMovies = 5
    case searchMovies = 6
}
