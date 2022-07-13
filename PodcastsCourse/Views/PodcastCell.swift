//
//  PodcastCell.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 12.07.2022.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            podcastImageView.layer.cornerRadius = 8
            trackNameLabel.text = podcast.trackName
            trackNameLabel.numberOfLines = 2
            artistNameLabel.text = podcast.artistName
            artistNameLabel.numberOfLines = 2
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                print(data)
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.podcastImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
     
}
