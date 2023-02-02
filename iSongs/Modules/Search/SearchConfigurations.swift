//
//  SearchConfigurations.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 30.01.2023.
//

import Foundation

final class SearchConfigurations {
    
    static let shared = SearchConfigurations()
    
    private init() {}
    
    func configure(with viewController: SearchViewController) {
        let viewController = viewController
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
