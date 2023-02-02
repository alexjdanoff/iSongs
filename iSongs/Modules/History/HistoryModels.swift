//
//  HistoryModels.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import UIKit

enum History {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getTracks
            }
        }
        struct Response {
            enum ResponseType {
                case presentTracks(tracks: [Track]?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTracks(historyViewModel: HistoryViewModel)
            }
        }
    }
}

struct HistoryViewModel {
    struct Cell: TrackCellViewModel {
        var previewUrl: String
        
        
        var trackId: Int
        var trackDuration: String
        var iconUrlString: String?
        var trackName: String
        var artistName: String
//        var previewUrl: String?
    }
    
    let cells: [Cell]
}
