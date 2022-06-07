//
//  Movie.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 30.05.2022.
//

import Foundation

struct MoviesResponse: NetflixMedia {
    let results: [Movie]
}
struct Movie: NetflixMedia {
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

