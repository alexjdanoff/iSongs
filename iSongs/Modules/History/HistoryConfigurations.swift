//
//  HistoryConfigurations.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import Foundation

final class HistoryConfigurations {

    static let shared = HistoryConfigurations()

    private init() {}

    func configure(with viewController: HistoryViewController) {
        let viewController = viewController
        let interactor = HistoryInteractor()
        let presenter = HistoryPresenter()
        let router = HistoryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
