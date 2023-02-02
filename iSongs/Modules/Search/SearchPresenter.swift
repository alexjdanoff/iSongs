//
//  SearchPresenter.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
    func presentAlert(error: Error)
}

final class SearchPresenter: SearchPresentationLogic {
    
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        DispatchQueue.main.async {
            switch response {
            case .presentTracks(let searchResults):
                let cells = searchResults?.results.map({ track in
                    self.cellViewModel(from: track)
                }) ?? []
                
                let searchViewModel = SearchViewModel.init(cells: cells)
                let viewModelData =  Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel)
                self.viewController?.displayData(viewModel: viewModelData)
            }
        }
    }
    
    func presentAlert(error: Error) {
        viewController?.displayAlert(with: error.localizedDescription)
    }
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        SearchViewModel.Cell.init(previewUrl: track.preview?.absoluteString ?? "",
                                  trackId: track.id ?? 0,
                                  trackDuration: track.readableDuration ?? "",
                                  iconUrlString: track.image?.absoluteString,
                                  trackName: track.title ?? "",
                                  artistName: track.artist ?? "")
    }
    
}
