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
    
    static let shared = APIService() // singleton
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    func downloadEpisode(episode: Episode) {
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        AF.download(episode.streamUrl, to: downloadRequest).response { (response) in
            print(response.description)
            
            // Update UserDefaults to get access to my episode from directory with downloaded episodes
            var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
            downloadedEpisodes[index].fileUrl = response.fileURL?.absoluteString ?? ""
            
            do {
                let data = try JSONEncoder().encode(downloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
            } catch let error {
                print("Failed to encode downloaded episodes with file url update:", error)
            }
        }
    }
    
    func fetchEpisodes(feedUrl: String, comleptionHandler: @escaping ([Episode]) -> Void) {
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
    
    func fetchPodacasts(searchText: String, completionHandler: @escaping ([Podcast]) -> Void) {
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
