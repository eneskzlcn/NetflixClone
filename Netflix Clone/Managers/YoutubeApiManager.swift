//
//  YoutubeApiCaller.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 13.06.2022.
//

import Foundation


class YoutubeApiManager {
    
    static let shared = YoutubeApiManager()
    
    func searchMediaContent(with query: String, completion: @escaping (Result<YoutubeSearchResponse,Error>)-> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseUrl)?q=\(query)&key=\(Constants.apiKey)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(ApiError.failedToFetchData))
            }
        }
        task.resume()
    }
    struct Constants {
        static let apiKey = "AIzaSyAeOp5m4xeSKck9Dlm6SXdJeyhOZf2TOA0"
        static let baseUrl = "https://youtube.googleapis.com/youtube/v3/search"
    }
}
