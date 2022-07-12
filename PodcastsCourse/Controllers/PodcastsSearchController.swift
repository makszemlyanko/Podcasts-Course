//
//  PodcastsSearchController.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 08.07.2022.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    // MARK: - Search Bar
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // implement Alamofire to search iTunes API
        APIService.shared.fetchPodacasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View
    
    fileprivate func setupTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib , forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
//        let podcast = self.podcasts[indexPath.row]
//        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
//        cell.textLabel?.numberOfLines = -1
//        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}


