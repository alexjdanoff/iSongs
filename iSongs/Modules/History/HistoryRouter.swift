//
//  HistoryRouter.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import UIKit

protocol HistoryDataPassing {
    func showTrackDetailsViewController(at index: Int)
    var dataStore: SearchHistoryDataStore? { get }
}

final class HistoryRouter: HistoryDataPassing {
    
    weak var viewController: HistoryViewController?
    var dataStore: SearchHistoryDataStore?
    
    func showTrackDetailsViewController(at index: Int) {
        let detailsVC = TrackDetailsViewController()
        detailsVC.trackID = dataStore?.tracks[index].id
        detailsVC.modalPresentationStyle = .overFullScreen
        viewController?.present(detailsVC, animated: true, completion: nil)
    }
}
