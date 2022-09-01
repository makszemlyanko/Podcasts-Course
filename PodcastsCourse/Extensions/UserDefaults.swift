//
//  UserDefaults.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 30.07.2022.
//

import Foundation

extension UserDefaults {
    
    static let favoritePodcastKey = "favoritePodcastKey"
    
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
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
