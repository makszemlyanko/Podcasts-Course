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
    
    let podcasts = [
        Podcast(name: "KOKos", artistName: "Name"),
        Podcast(name: "Maks", artistName: "Name"),
        Podcast(name: "Velikan", artistName: "Name")
    ]
    
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
        // Later we will implement Alamofire to search iTunes API
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        AF.request(url).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact", err)
                return
            }
            guard let data = dataResponse.data else { return }
            let dummyStrng = String(data: data, encoding: .utf8)
            print(dummyStrng ?? "")
        }
    }
    
    // MARK: - Table View
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let podcast = self.podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        
        return cell
    }
}


