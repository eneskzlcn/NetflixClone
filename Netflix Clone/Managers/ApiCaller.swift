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
   
    func getMovies(section: MediaSection , completion: @escaping(Result<MediaResponse,Error>)->Void) {
        switch section {
        case .trendingMovies:
            URLSession.shared.getMedias(url: fullUrl(for: .trendingMovies), completion: completion)
        case .trendingTvs:
            URLSession.shared.getMedias(url: fullUrl(for: .trendingTvs), completion: completion)
        case .topRatedMovies:
            URLSession.shared.getMedias(url: fullUrl(for: .topRatedMovies, params: .languageAndPage), completion: completion)
        case .upcomingMovies:
            URLSession.shared.getMedias(url: fullUrl(for: .upcomingMovies, params: .languageAndPage), completion: completion)
        case .popularMovies:
            URLSession.shared.getMedias(url: fullUrl(for: .popularMovies, params: .languageAndPage), completion: completion)
        }
    }
    private func fullUrl(for section: MediaSection, params: ApiQueryParams? = .none) -> String {
        var url = "\(Constants.baseURL)\(routes[section]!)?api_key=\(Constants.API_KEY)"
        if let params = params {
            url+=params.rawValue
        }
        return url
    }
    let routes: [MediaSection: String] = [
        .topRatedMovies: "/movie/top_rated",
        .upcomingMovies: "/movie/upcoming",
        .popularMovies: "/movie/popular",
        .trendingMovies: "/trending/movie/day",
        .trendingTvs: "/trending/tv/day"
    ]
    enum ApiRoutes: String {
        case trendingTvsRoute = "/trending/tv/day"
        case trendingMoviesRoute = "/trending/movie/day"
        case upcomingMoviesRoute = "/movie/upcoming"
        case popularMoviesRoute = "/movie/popular"
        case topRatedMoviesRoute = "/movie/top_rated"
    }
    enum ApiQueryParams: String {
        case languageAndPage = "&language=en-US&page=1"
    }
    struct Constants {
        static let baseURL = "https://api.themoviedb.org/3"
        static let API_KEY = "d510c98dae7bbe1625911ac648cb479d"
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

/* Classical Type Of Url Session Data Fetch For Getting Trending Movies
 
    func getTrendingMovies(completion: @escaping(Result<[Movie],Error>)->Void) {
        guard let url=URL(string: fullApiURL(for: .trendingMoviesRoute)) else{ return }
        let task=URLSession.shared.dataTask(with:URLRequest(url:url)){ data,_,error in
            guard let data=data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self,from:data)
                completion(.success(results.results))
            }catch{
                completion(.failure(ApiError.failedToFetchData))
            }
        }
        task.resume()
    }
    
*/
