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
    
    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }
    
    deinit {
        print("PlayerDetailView memory being reclaimed...")
    }

    // MARK: - IB Outlets
    
    // Image
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = shrunkenTransform
            episodeImageView.contentMode = .scaleAspectFill
            episodeImageView.layer.cornerRadius = 8
        }
    }
    
    // Title
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthorLabel: UILabel!
    
    // Duration
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var episodeDurationSlider: UISlider! {
        didSet {
            episodeDurationSlider.tintColor = .systemPurple
        }
    }
    
    // Control buttons
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var episodeVolume: UISlider! {
        didSet {
            episodeVolume.tintColor = .lightGray
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = episodeDurationSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func handleVolume(_ sender: UISlider) {
        player.volume = episodeVolume.value
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    // MARK: - Another methods
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationtime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationtime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1 ))
        let percentage = currentTimeSeconds / durationSeconds
        self.episodeDurationSlider.value = Float(percentage)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("episode started playing")
            self?.enlargeEpisodeImageView()
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
    
    // MARK: - Episode image animating
    
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
