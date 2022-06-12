//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 12.06.2022.
//

import Foundation


final class SearchResultsViewModel {
    

    typealias SearchListener = ([Media]) -> Void
    
    var searchResult: ObservableObject<[Media]> = ObservableObject([Media]())
    
    init() {
        ApiCaller.shared.getMedias(section: .topRatedMovies, completion: {[weak self] results in
            switch results {
            case .success(let mediaResponse):
                self?.searchResult = ObservableObject(mediaResponse.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    func bind(listener: @escaping SearchListener) {
        searchResult.bind(listener)
    }
    
    func media(at: Int) -> Media {
        searchResult.value[at]
    }
    
    func search(with query: String){
        ApiCaller.shared.search(for: query){ [weak self] results in
            switch results {
            case .success(let mediaResponse):
                self?.searchResult.value = mediaResponse.results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
