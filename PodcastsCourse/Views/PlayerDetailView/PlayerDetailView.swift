//
//  PlayerDetailView.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 17.07.2022.
//

import UIKit

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            episodeAuthorLabel.text = episode.author
            episodeTitleLabel.text = episode.title
            episodeTitleLabel.numberOfLines = 2
            episodeImageView.contentMode = .scaleAspectFill
            episodeImageView.layer.cornerRadius = 8
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return } // episode image
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthorLabel: UILabel!
    @IBOutlet weak var episodeDuration: UISlider! {
        didSet {
            episodeDuration.tintColor = .systemPurple
        }
    }
    @IBOutlet weak var episodeVolume: UISlider! {
        didSet {
            episodeVolume.tintColor = .lightGray
        }
    }
    
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
}
