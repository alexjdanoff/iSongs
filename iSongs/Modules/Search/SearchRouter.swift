//
//  SearchRouter.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 28.01.2023.
//

import UIKit

protocol SearchDataPassing {
    func showTrackDetailsViewController(at index: Int)
    var dataStore: SearchMusicDataStore? { get }
}

final class SearchRouter: SearchDataPassing {
    
    weak var viewController: SearchViewController?
    var dataStore: SearchMusicDataStore?
    
    func showTrackDetailsViewController(at index: Int) {
        let detailsVC = TrackDetailsViewController()
        detailsVC.trackID = dataStore?.trackIDs[index]
        detailsVC.modalPresentationStyle = .overFullScreen
        viewController?.present(detailsVC, animated: true, completion: nil)
    }
}
