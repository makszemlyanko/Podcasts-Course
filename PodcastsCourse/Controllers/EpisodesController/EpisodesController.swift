//
//  EpisodesController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 14.07.2022.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    private let cellId = "cellId"
    
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    private func fetchEpisodes() {
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
    
    private func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView() // remove horizontal lines
    }
    
    // MARK: - NavigationBar Buttons
    
    private func setupNavigationBarButtons() {
        
        // checking saved podcast or not
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorite = savedPodcasts.firstIndex(where: {$0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
        if hasFavorite {
            // setup heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleSaveFavorite))
        }
    }
    
    // saving data into UserDefaults
    @objc func handleSaveFavorite() {
        print(#function)
        guard let podcast = self.podcast else { return }
        do {
            var listOfPodcasts = UserDefaults.standard.savedPodcasts()
            listOfPodcasts.append(podcast)
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: true)
            UserDefaults.standard.setValue(data, forKey: UserDefaults.favoritePodcastKey)
        } catch let error {
            print(error.localizedDescription)
        }
        
        showBadgeHightlight() // tabBar badge
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
    }
    
    private func showBadgeHightlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let downloadAction = UIContextualAction(style: .normal, title: "Download") { (_, _, completion)  in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            completion(true)
            
            // Download the episode with Alamofire
            APIService.shared.downloadEpisode(episode: episode)
        }
        downloadAction.backgroundColor = .systemPurple
        let swipeActions = UISwipeActionsConfiguration(actions: [downloadAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        episodes.isEmpty ? 550 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetail(episode: episode)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        116
    }
}
