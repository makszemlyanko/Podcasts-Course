//
//  CMTime.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 19.07.2022.
//

import AVKit

extension CMTime {
    func toDisplayString() -> String {
        let totalSeconds = CMTimeGetSeconds(self)
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
