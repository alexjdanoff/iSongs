//
//  HistoryPresenter.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 31.01.2023.
//

import UIKit

protocol HistoryPresentationLogic {
    func presentData(response: History.Model.Response.ResponseType)
}

final class HistoryPresenter: HistoryPresentationLogic {
    
    weak var viewController: HistoryDisplayLogic?
    
    func presentData(response: History.Model.Response.ResponseType) {
        DispatchQueue.main.async {
            switch response {
            case .presentTracks(let tracks):
                let cells = tracks?.map { self.cellViewModel(from: $0) }
                let historyViewModel = HistoryViewModel.init(cells: cells ?? [])
                let viewModelData = History.Model.ViewModel.ViewModelData.displayTracks(historyViewModel: historyViewModel)
                self.viewController?.displayData(viewModel: viewModelData)
            }
        }
    }
    
    private func cellViewModel(from track: Track) -> HistoryViewModel.Cell {
        HistoryViewModel.Cell.init(previewUrl: track.preview?.absoluteString ?? "",
                                   trackId: track.id ?? 0,
                                   trackDuration: track.readableDuration ?? "",
                                   iconUrlString: track.image?.absoluteString,
                                   trackName: track.title ?? "",
                                   artistName: track.artist ?? "")
    }
}
