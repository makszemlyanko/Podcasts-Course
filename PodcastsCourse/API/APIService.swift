//
//  APIService.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 11.07.2022.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService() //singleton
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    func fetchPodacasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact", err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                print("Result Count: ", searchResult.resultCount)
                completionHandler(searchResult.results)
                searchResult.results.forEach { (podcast) in
                    print(podcast.artistName ?? "", podcast.trackName ?? "")
                }
            } catch let decodeError {
                print("Failed to decode: ", decodeError)
            }
        }
    }
}
