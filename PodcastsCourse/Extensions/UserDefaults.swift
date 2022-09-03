//
//  UserDefaults.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 30.07.2022.
//

import Foundation

extension UserDefaults {
    
    static let favoritePodcastKey = "favoritePodcastKey"
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return [] }
        do {
            guard let savedPodcasts =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return [] }
            return savedPodcasts

        } catch let error {
            print(error)
        }
        return savedPodcasts()
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteEpisode(episode: Episode) {
        let episodes = downloadedEpisodes()
        let filteredEpisodes = episodes.filter { (epis) -> Bool in
            epis.author != episode.author && epis.title != episode.title
        }
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func downloadEpisode(episode: Episode) {
        do {
            var eisodes = downloadedEpisodes()
            eisodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(eisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        guard let episodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
}
