//
//  Podcast.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 29.07.2022.
//

import Foundation

class Podcast: NSObject, NSCoding, NSSecureCoding, Decodable {
    
    static var supportsSecureCoding: Bool = true
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
    func encode(with coder: NSCoder) {
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkUrl600Key")
    }
    
    required init?(coder: NSCoder) {
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistName") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkUrl600") as? String
    }

}
