//
//  PlayerDetailView.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 17.07.2022.
//

import UIKit
import AVKit

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            episodeAuthorLabel.text = episode.author
            episodeTitleLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return } // episode image
            episodeImageView.sd_setImage(with: url, completed: nil)
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
        let avp = AVPlayer()
        avp.automaticallyWaitsToMinimizeStalling = false
        return avp
    }()
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    // MARK: - IB Outlets and IB Actions
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = shrunkenTransform
            episodeImageView.contentMode = .scaleAspectFill
            episodeImageView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    
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
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        player.pause()
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            print("episode started playing")
            self.enlargeEpisodeImageView()
        }
    }
    
    @objc fileprivate func handlePlayPause() {
        print("play and pause button")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    fileprivate func playEpisode() {
        print("trying to play episode:", episode.streamUrl)
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Episode image animate
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = self.shrunkenTransform
        }
    }
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = .identity
        }
    }
    

}
