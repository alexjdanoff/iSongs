//
//  TrackCell.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var trackDuration: String { get }
}

final class TrackCell: UITableViewCell {
    
    private var trackImageView = UIImageView()
    private var trackTitleLabel = UILabel()
    private var artistNameLabel = UILabel()
    private var trackDurationLabel = UILabel()
    private var activityIndicator = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        trackImageView.image = nil
        [trackTitleLabel, artistNameLabel, trackDurationLabel].forEach {
            $0.text = nil
        }
        activityIndicator.startAnimating()
    }
    
    // MARK: - Setup constraints
    private func layoutViews() {
        [trackImageView, trackTitleLabel, artistNameLabel, trackDurationLabel, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let imageConstraints = [
            trackImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            trackImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackImageView.heightAnchor.constraint(equalToConstant: 56),
            trackImageView.widthAnchor.constraint(equalToConstant: 56)
        ]
        let trackTitleConstraints = [
            trackTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 88),
            trackTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            trackTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46)
        ]
        let artistNameConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 4),
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 88),
        ]
        let trackDurationConstraints = [
            trackDurationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trackDurationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        let activityConstraints = [
            activityIndicator.centerYAnchor.constraint(equalTo: trackImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: trackImageView.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ]
        [imageConstraints, trackTitleConstraints, artistNameConstraints, trackDurationConstraints, activityConstraints].forEach { NSLayoutConstraint.activate($0)
        }
    }
    
    // MARK: - Configure view
    private func configureView() {
        [trackImageView, trackTitleLabel, artistNameLabel, trackDurationLabel, activityIndicator].forEach {
            addSubview($0)
        }
        
        selectionStyle = .none
        activityIndicator.startAnimating()
        layoutViews()
    }
    
    func configure(with viewModel: TrackCellViewModel) {
        
        if let urlString = viewModel.iconUrlString {
            guard let url = URL(string: urlString) else { return }
            setImage(url: url)
        }
        
        trackImageView.layer.cornerRadius = 8
        trackImageView.clipsToBounds = true
        
        trackTitleLabel.text = viewModel.trackName
        trackTitleLabel.numberOfLines = 1
        trackTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        trackTitleLabel.textAlignment = .left
        
        artistNameLabel.text = viewModel.artistName
        artistNameLabel.numberOfLines = 1
        artistNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        artistNameLabel.textAlignment = .left
        
        trackDurationLabel.text = viewModel.trackDuration
        trackDurationLabel.textColor = .gray
        trackDurationLabel.numberOfLines = 1
        trackDurationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        trackDurationLabel.textAlignment = .center
        
        
        
        activityIndicator.color = #colorLiteral(red: 0.937254902, green: 0.1960784314, blue: 0.3725490196, alpha: 1)
        activityIndicator.hidesWhenStopped = true
    }
    
    func setImage(url: URL) {
        trackImageView.sd_setImage(with: url, completed: nil)
        activityIndicator.stopAnimating()
    }
    
}
