//
//  EpisodeCell.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 15.07.2022.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            pubDateLabel.text = episode.pubDate.description
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            let dateFormatter = DateFormatter() // date sittings
            dateFormatter.dateFormat = "MMM, dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            episodeImageView.contentMode = .scaleAspectFit
            episodeImageView.layer.cornerRadius = 8
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return } // episode image
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }

    @IBOutlet weak var episodeImageView: UIImageView!

    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
}
