//
//  Podcast.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 29.07.2022.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

class Podcast: NSObject, Decodable, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
    func encode(with coder: NSCoder) {
        print(#function)
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkUrl600Key")
    }
    
    required init?(coder: NSCoder) {
        print(#function)
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkUrl600") as? String
    }
    

}
