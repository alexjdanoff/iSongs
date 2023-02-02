//
//  TrackDetailsInteractor.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 29.01.2023.
//

import Foundation

protocol TrackDetailsBusinessLogic {
    func showTrackDetails(request: TrackDetails.ShowTrackDetails.Request)
}

final class TrackDetailsInteractor: TrackDetailsBusinessLogic {
    
    var networkService = NetworkService.shared
    var presenter: TrackDetailsPresentationLogic?
    
    func showTrackDetails(request: TrackDetails.ShowTrackDetails.Request) {
        guard let url = URLBuilder().buildTrackDetailsSearch(trackID: request.trackID) else {
            presenter?.presentAlert(error: CustomErrors.wrongData)
            return
        }
        
        networkService.fetchData(from: url, resultType: TrackResponse.self, complition: { result in
            switch result {
            case .success(let searchResponse):
                let response = TrackDetails.ShowTrackDetails.Response(trackDetails: searchResponse)
                self.presenter?.presentTrackDetails(response: response)
            case .failure(let error):
                self.presenter?.presentAlert(error: error)
            }
        })
    }
}
