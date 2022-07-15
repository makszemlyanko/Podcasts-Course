//
//  RSSFeed.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 15.07.2022.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]()
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        })
        return episodes
    }
}
