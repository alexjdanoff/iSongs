//
//  SearchViewController.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
    func displayAlert(with text: String)
}

final class SearchViewController: UIViewController {
    
    var interactor: SearchBusinessLogic?
    var router: SearchRouter?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        configureView()
        SearchConfigurations.shared.configure(with: self)
    }
    
    // MARK: - Setup constraints
    private func layoutViews() {
        [searchBar, tableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let searchBarConstraints  = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ]
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        [searchBarConstraints, tableViewConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
    
    // MARK: - Configure view
    private func configureView() {
        tableView.register(cellType: TrackCell.self)
        tableView.addTableHeaderViewLine()
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.center = view.center
        activityIndicator.color = #colorLiteral(red: 0.937254902, green: 0.1960784314, blue: 0.3725490196, alpha: 1)
        activityIndicator.hidesWhenStopped = true
        
        [searchBar, tableView, activityIndicator].forEach { view.addSubview($0) }
        layoutViews()
    }
}

// MARK: - Display logic
extension SearchViewController: SearchDisplayLogic {
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let searchViewModel):
            self.searchViewModel = searchViewModel
            tableView.reloadData()
            activityIndicator.stopAnimating()
            guard searchViewModel.cells.isEmpty else { return }
            displayAlert(with: CustomErrors.searchResultEmpty.localizedDescription)
        }
    }
    
    func displayAlert(with text: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Search error", message: text)
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Search bar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.count > 2 {
            activityIndicator.startAnimating()
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                let request = Search.Model.Request.RequestType.getTracks(searchTerm: searchText)
                self.interactor?.makeRequest(request: request)
            })
            
        } else {
            self.searchViewModel = SearchViewModel.init(cells: [])
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TrackCell.self, for: indexPath)
        cell.configure(with: searchViewModel.cells[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.showTrackDetailsViewController(at: indexPath.row)
    }
}
