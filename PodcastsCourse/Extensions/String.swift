//
//  String.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 15.07.2022.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
