//
//  TrackDetailsPresenter.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 29.01.2023.
//

import UIKit

protocol TrackDetailsPresentationLogic {
    func presentTrackDetails(response: TrackDetails.ShowTrackDetails.Response)
    func presentAlert(error: Error)
}

final class TrackDetailsPresenter: TrackDetailsPresentationLogic {
    
    weak var viewController: TrackDetailsDisplayLogic?
    private let coreManager = CoreManager.shared
    
    func presentTrackDetails(response: TrackDetails.ShowTrackDetails.Response) {
        let details = response.trackDetails.results
        
        guard let title = details.first?.title,
              let artist = details.first?.artist,
              let imageURL = details.first?.image,
              let preview = details.first?.preview,
              let id = details.first?.id,
              let duration = details.first?.durationInMilliseconds else { return }
        
        let viewModel = TrackDetails.ShowTrackDetails.ViewModel(imageURL: imageURL.absoluteString,
                                                                trackName: title,
                                                                artistName: artist,
                                                                previewUrl: preview.absoluteString)
        
        let track = Track(id: id,
                          title: title,
                          artist: artist,
                          image: imageURL,
                          duration: duration,
                          preview: preview)
        
        coreManager.save(track)
        
        viewController?.displayTrackDetails(viewModel: viewModel)
    }
    
    func presentAlert(error: Error) {
        viewController?.displayAlert(with: error.localizedDescription)
    }
    
}
