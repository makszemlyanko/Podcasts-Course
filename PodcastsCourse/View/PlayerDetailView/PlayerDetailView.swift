//
//  PlayerDetailView.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 17.07.2022.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailView: UIView {

    var episode: Episode! {
        didSet {
            episodeAuthorLabel.text = episode.author
            episodeTitleLabel.text = episode.title
            miniEpisodeTitleLabel.text = episode.title
            playEpisode()
            guard let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url) { (image, _, _, _) in
                guard let image = image else { return  }
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                let artWork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                    return image
                }
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artWork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }
    }

    let player: AVPlayer = {
        let avp = AVPlayer()
        avp.automaticallyWaitsToMinimizeStalling = false
        return avp
    }()

    var panGesture: UIPanGestureRecognizer!

    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }

    deinit {
        print("PlayerDetailView memory being reclaimed...")
    }

    // MARK: - IB Outlets

    @IBOutlet weak var miniEpisodeImageView: UIImageView! {
        didSet {
            miniEpisodeImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var miniEpisodeTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
        }
    }

    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = shrunkenTransform
            episodeImageView.contentMode = .scaleAspectFit
            episodeImageView.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthorLabel: UILabel!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var episodeDurationSlider: UISlider! {
        didSet {
            episodeDurationSlider.tintColor = .systemPurple
        }
    }

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
        UIApplication.mainTabBarController()?.minimizePlayerDetail()
    }

    private func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }

    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationtime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationtime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }

    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1 ))
        let percentage = currentTimeSeconds / durationSeconds
        self.episodeDurationSlider.value = Float(percentage)
    }

    private func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan)))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAudioSession()
        setupGestures()
        observePlayerCurrentTime()

        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]

        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("episode started playing")
            self?.enlargeEpisodeImageView()
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }

    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionError {
            print("Failed to activate session: \(sessionError)")
        }
    }

    @objc private func handlePlayPause() {
        print("play and pause button")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }

    private func playEpisode() {
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            print("trying to play episode from stream Url:", episode.streamUrl)
            guard let url = URL(string: episode.streamUrl) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }

    private func playEpisodeUsingFileUrl() {
        print("trying to play episode from file Url:", episode.fileUrl ?? "")

        // figure out the file name for our episode file url
        guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent

        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        trueLocation.appendPathComponent(fileName)

        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    // MARK: - Episode image animating

    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = self.shrunkenTransform
        }
    }

    private func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = .identity
        }
    }
}
