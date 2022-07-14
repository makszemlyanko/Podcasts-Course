//
//  v.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 10.07.2022.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

struct Episode: Decodable {
    var title: String?
}
