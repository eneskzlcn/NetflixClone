//
//  YoutubeMedia.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 13.06.2022.
//

import Foundation

protocol YoutubeContent: Codable {}

struct YoutubeSearchResponse: YoutubeContent {
    let items: [YoutubeVideoElement]
}

struct YoutubeVideoElement: YoutubeContent {
    let id: YoutubeElementId
}

struct YoutubeElementId: YoutubeContent {
    let kind: String
    let videoId: String
}
