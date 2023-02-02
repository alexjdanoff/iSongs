//
//  HistoryViewController.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

protocol HistoryDisplayLogic: AnyObject {
    func displayData(viewModel: History.Model.ViewModel.ViewModelData)
}

final class HistoryViewController: UIViewController {
    
    private let tableView = UITableView()
    var interactor: HistoryBusinessLogic?
    var router: HistoryRouter?
    
    private var historyViewModel = HistoryViewModel.init(cells: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        HistoryConfigurations.shared.configure(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func refreshData() {
        let request = History.Model.Request.RequestType.getTracks
        interactor?.makeRequest(request: request)
        tableView.reloadData()
    }
    
    // MARK: - Setup constraints
    private func layoutViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
        
    // MARK: - Configure view
    private func configureView() {
        tableView.register(cellType: TrackCell.self)
        tableView.addTableHeaderViewLine()
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        layoutViews()
    }
}

// MARK: - Display logic
extension HistoryViewController: HistoryDisplayLogic {
        
    func displayData(viewModel: History.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let historyViewModel):
            self.historyViewModel = historyViewModel
            tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TrackCell.self, for: indexPath)
        cell.configure(with: historyViewModel.cells[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.showTrackDetailsViewController(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
            interactor?.removeTrack(at: indexPath.row)
            refreshData()
    }
}
