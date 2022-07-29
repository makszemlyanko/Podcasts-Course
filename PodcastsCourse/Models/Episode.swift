//
//  Episode.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 29.07.2022.
//

import Foundation
import FeedKit

struct Episode: Decodable {
    let title: String
    let author: String
    let pubDate: Date
    let description: String
    var imageUrl: String?
    let streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
}
