//
//  TrackDetailsConfiguration.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 29.01.2023.
//

import Foundation

final class TrackDetailsConfiguration {
    
    static let shared = TrackDetailsConfiguration()
    
    private init() {}
    
    func configure(with viewController: TrackDetailsViewController) {
        let viewController = viewController
        let interactor = TrackDetailsInteractor()
        let presenter = TrackDetailsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}
