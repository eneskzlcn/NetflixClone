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
    
    func getTrendingMoviesGenericly(completion: @escaping(Result<TrendingMoviesResponse,Error>)->Void) {
        URLSession.shared.getMedias(url: fullApiURL(for: .trendingMoviesRoute), completion: completion)
    }
    func getTrendingTvsGenericly(completion: @escaping(Result<TrendingTvsResponse,Error>)->Void) {
        URLSession.shared.getMedias(url: fullApiURL(for: .trendingTvsRoute), completion: completion)
    }
    private func fullApiURL(for route: ApiRoutes) -> String {
        "\(Constants.baseURL)\(route.rawValue)?api_key=\(Constants.API_KEY)"
    }
    
    enum ApiRoutes: String {
        case trendingTvsRoute = "/3/trending/tv/day"
        case trendingMoviesRoute = "/3/trending/movie/day"
    }
    struct Constants {
        static let baseURL = "https://api.themoviedb.org"
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
