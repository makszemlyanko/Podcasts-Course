//
//  DownloadsController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 02.09.2022.
//

import UIKit

class DownloadsController: UITableViewController {
    
    private let cellId = "cellId"
    
    private var episodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc private func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        print(progress, title)
        
        // lets find the index using title
        guard let index = self.episodes.firstIndex(where: { $0.title == title }) else { return }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
    @objc private func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        
        guard let index = self.episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetail(episode: episode)            
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, use internet for playing", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.maximizePlayerDetail(episode: episode)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let episode = self.episodes[indexPath.row]
            self.episodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.deleteEpisode(episode: episode)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        116
    }
}
