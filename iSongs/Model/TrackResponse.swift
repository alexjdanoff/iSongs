//
//  TrackResponse.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import Foundation

public struct TrackResponse: Codable {
    var results: [Track]
}

public struct Track: Codable {
    
    var readableDuration: String? {
        let formatter = DateComponentsFormatter()
        let durationInSeconds = TimeInterval(durationInMilliseconds / 1000)
        
        return formatter.string(from: durationInSeconds)
    }
    
    let id: Int?
    let artist: String?
    var title: String?
    let preview: URL?
    let image: URL?
    let durationInMilliseconds: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case artist = "artistName"
        case title = "trackName"
        case preview = "previewUrl"
        case image = "artworkUrl100"
        case durationInMilliseconds = "trackTimeMillis"
    }
    
    init(from core: CoreTrack) {
        self.id = Int(core.id)
        self.artist = core.artist
        self.title = core.title
        self.image = core.image
        self.durationInMilliseconds = Int(core.duration)
        self.preview = core.preview
    }
    
    init(id: Int?,
         title: String?,
         artist: String?,
         image: URL?,
         duration: Int,
         preview: URL?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.image = image
        self.durationInMilliseconds = duration
        self.preview = preview
    }
}
