//
//  SearchModels.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

enum Search {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getTracks(searchTerm: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentTracks(trackResponse: TrackResponse?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTracks(searchViewModel: SearchViewModel)
            }
        }
    }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        
        var previewUrl: String
        var trackId: Int
        var trackDuration: String
        var iconUrlString: String?
        var trackName: String
        var artistName: String
    }
    
    let cells: [Cell]
}
