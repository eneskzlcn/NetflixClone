//
//  ApiCaller.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 30.05.2022.
//

import Foundation

enum ApiError: Error {
    case failedToFetchData
}
class ApiCaller {
    static let shared = ApiCaller()

    func getMedias(section: MediaSection, completion: @escaping(Result<MediaResponse,Error>)->Void) {
        if section == .trendingMovies || section == .trendingTvs {
            URLSession.shared.getMedias(url: fullUrl(for: section), completion: completion)
        }else {
            URLSession.shared.getMedias(url: fullUrl(for: section, params: .languageAndPage), completion: completion)
        }
    }
    func search(for query: String,completion: @escaping(Result<MediaResponse,Error>)->Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else { return }
        let urlWithQuery = "\(fullUrl(for: .searchMovies))&query=\(query)"
        URLSession.shared.getMedias(url: urlWithQuery, completion: completion)
    }
    private func fullUrl(for section: MediaSection, params: ApiQueryParams? = .none) -> String {
        var url = "\(Constants.baseURL)\(routes[section]!)?api_key=\(Constants.API_KEY)"
        if let params = params {
            url+=params.rawValue
        }
        return url
    }
    public func posterUrl(for posterPath: String) -> String {
        "\(Constants.posterBaseURL)\(posterPath)"
    }
    let routes: [MediaSection: String] = [
        .topRatedMovies: "/movie/top_rated",
        .upcomingMovies: "/movie/upcoming",
        .popularMovies: "/movie/popular",
        .discoverMovies: "/discover/movie",
        .trendingMovies: "/trending/movie/day",
        .trendingTvs: "/trending/tv/day",
        .searchMovies: "/search/movie"
    ]
    
    enum ApiQueryParams: String {
        case languageAndPage = "&language=en-US&page=1"
    }
    struct Constants {
        static let baseURL = "https://api.themoviedb.org/3"
        static let API_KEY = "d510c98dae7bbe1625911ac648cb479d"
        static let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
    }
}

extension URLSession {
    func getMedias<T: NetflixMedia> (url to: String, completion: @escaping(Result<T, Error>)->Void ) {
        guard let url = URL(string: to) else{ return }
        let task = self.dataTask(with: URLRequest(url:url)) { data, _, error in
            guard let data=data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(T.self,from:data)
                completion(.success(results))
            }catch{
                completion(.failure(ApiError.failedToFetchData))
            }
        }
        task.resume()
    }
}
