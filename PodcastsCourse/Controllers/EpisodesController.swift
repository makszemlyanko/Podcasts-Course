//
//  EpisodesController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 14.07.2022.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate let favoritePodcastKey = "favoritePodcastKey"
    
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    

    fileprivate func fetchEpisodes() {
        print("looking for episodes", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    // MARK: - Setup table view
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView() // remove horizontal lines
    }
    
    fileprivate func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddToFavorites))
    }
    
    @objc func handleAddToFavorites() {
        handleFetchSavedPodcast()
        handleFetchSavedPodcast()
    }
    
    func handleFetchSavedPodcast() {
        print(#function)
        let value = UserDefaults.standard.value(forKey: favoritePodcastKey) as? String
        print(value ?? "")
        
        guard let data = UserDefaults.standard.data(forKey: favoritePodcastKey) else { return }
        do {
            let podcast = try NSKeyedUnarchiver.unarchivedObject(ofClass: Podcast.self, from: data) as? Podcast
            print(podcast?.artistName, podcast?.trackName)
        } catch let error {
            print(error)
        }
        
        func handleSaveFavorite() {
            print(#function)
            guard let podcast = self.podcast else { return }
            //        UserDefaults.standard.setValue(podcast.trackName, forKey: favoritePodcastKey)
            
            // 1. transform Podcast into Data
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: podcast, requiringSecureCoding: true)
                UserDefaults.standard.setValue(data, forKey: favoritePodcastKey)
            } catch let error {
                print(error)
            }
        }
    }
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 550 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetail(episode: episode)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
}
