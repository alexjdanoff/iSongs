//
//  SearchInteractor.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

protocol SearchMusicDataStore {
    var trackIDs: [Int] { get set }
}

final class SearchInteractor: SearchBusinessLogic, SearchMusicDataStore {
    
    var networkService = NetworkService.shared
    var presenter: SearchPresentationLogic?
    
    var trackIDs: [Int] = []
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        switch request {
        case .getTracks(let searchTerm):
            
            guard let url = URLBuilder().buildTrackSearch(searchText: searchTerm) else {
                presenter?.presentAlert(error: CustomErrors.searchResultEmpty)
                return
            }
            
            networkService.fetchData(from: url, resultType: TrackResponse.self, complition: { result in
                switch result {
                case .success(let trackResponse):
                    self.trackIDs = []
                    let response = Search.Model.Response.ResponseType.presentTracks(trackResponse: trackResponse)
                    self.presenter?.presentData(response: response)
                    trackResponse.results.forEach { self.trackIDs.append($0.id ?? 0) }
                case .failure(let error):
                    self.presenter?.presentAlert(error: error)
                }
            })
        }
    }
    
}
