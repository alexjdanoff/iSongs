//
//  TrackDetailsModels.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 29.01.2023.
//

import UIKit

enum TrackDetails {
    
    enum ShowTrackDetails {
        
        struct Request {
            let trackID: Int
        }
        
        struct Response {
            let trackDetails: TrackResponse
        }
        
        struct ViewModel {
            let imageURL: String
            let trackName: String
            let artistName: String
            let previewUrl: String
        }
    }
}
