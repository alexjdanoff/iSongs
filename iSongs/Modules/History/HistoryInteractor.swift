//
//  HistoryInteractor.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import UIKit

protocol HistoryBusinessLogic {
    func makeRequest(request: History.Model.Request.RequestType)
    func removeTrack(at index: Int)
}

protocol SearchHistoryDataStore {
    var tracks: [Track] { get set }
}

final class HistoryInteractor: HistoryBusinessLogic, SearchHistoryDataStore {
    
    var coreManager = CoreManager.shared
    var presenter: HistoryPresentationLogic?
    
    var tracks: [Track] = []
    
    func makeRequest(request: History.Model.Request.RequestType) {
        switch request {
        case .getTracks:
            let tracks = coreManager.load()
            let response = History.Model.Response.ResponseType.presentTracks(tracks: tracks)
            self.presenter?.presentData(response: response)
            self.tracks = tracks
        }
    }
    
    func removeTrack(at index: Int) {
        coreManager.delete(tracks[index])
    }
    
}
