//
//  APIService.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 11.07.2022.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    static let shared = APIService() //singleton
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    func fetchEpisodes(feedUrl: String, comleptionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                switch result {
                case .success(let feed):
                    switch feed {
                    case let .rss(feed):
                        let episodes = feed.toEpisodes()
                        comleptionHandler(episodes)
                    default:
                        print("Found a feed..")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
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
    
    struct SearchResult: Decodable {
        var resultCount: Int
        var results: [Podcast]
    }

}
