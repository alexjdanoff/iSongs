//
//  TrackDetailsViewController.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 28.01.2023.
//

import UIKit
import AVKit
import SDWebImage

protocol TrackDetailsDisplayLogic: AnyObject {
    func displayTrackDetails(viewModel: TrackDetails.ShowTrackDetails.ViewModel)
    func displayAlert(with text: String)
}

final class TrackDetailsViewController: UIViewController {
    
    var interactor: TrackDetailsBusinessLogic?
    var trackID: Int?
    
    private let containerView = UIView()
    private let lineDragView = UIView()
    private let panGestureView = UIView()
    private let trackImageView = UIImageView()
    private let trackTitleLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let trackTimeSlider = CustomSlider()
    private let timePassedLabel = UILabel()
    private let timeLeftLabel = UILabel()
    private let playPauseButton = UIButton()
    
    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        TrackDetailsConfiguration.shared.configure(with: self)
        
        let request = TrackDetails.ShowTrackDetails.Request(trackID: trackID ?? 0)
        interactor?.showTrackDetails(request: request)
    }
    
    // MARK: - Setup constraints
    private func layoutViews() {
        [containerView, lineDragView, trackImageView, trackTitleLabel, artistNameLabel, trackTimeSlider, timePassedLabel, timeLeftLabel, playPauseButton, panGestureView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let containerViewConstraints  = [
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let lineDragViewConstraints = [
            lineDragView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            lineDragView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lineDragView.heightAnchor.constraint(equalToConstant: 4),
            lineDragView.widthAnchor.constraint(equalToConstant: 60)
        ]
        let trackImageViewConstraints = [
            trackImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            trackImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trackImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 65),
            trackImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),
            trackImageView.heightAnchor.constraint(equalTo: trackImageView.widthAnchor)
        ]
        let trackTitleLabelConstraints = [
            trackTitleLabel.topAnchor.constraint(equalTo: trackImageView.bottomAnchor, constant: 24),
            trackTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trackTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            trackTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 4),
            artistNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        let currentTimeSliderConstraints = [
            trackTimeSlider.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 28),
            trackTimeSlider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trackTimeSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            trackTimeSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        let timePassedLabelConstraints = [
            timePassedLabel.topAnchor.constraint(equalTo: trackTimeSlider.bottomAnchor, constant: 6),
            timePassedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        ]
        let timeLeftLabelConstraints = [
            timeLeftLabel.topAnchor.constraint(equalTo: trackTimeSlider.bottomAnchor, constant: 6),
            timeLeftLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ]
        let playPauseButtonConstraints = [
            playPauseButton.topAnchor.constraint(equalTo: trackTimeSlider.bottomAnchor, constant: 48),
            playPauseButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playPauseButton.heightAnchor.constraint(equalToConstant: 55),
            playPauseButton.widthAnchor.constraint(equalToConstant: 49)
        ]
        let panGestureViewConstrains = [
            panGestureView.topAnchor.constraint(equalTo: containerView.topAnchor),
            panGestureView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            panGestureView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            panGestureView.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        
        [containerViewConstraints, lineDragViewConstraints, trackImageViewConstraints, trackTitleLabelConstraints, artistNameLabelConstraints, currentTimeSliderConstraints, timePassedLabelConstraints, timeLeftLabelConstraints, playPauseButtonConstraints, panGestureViewConstrains].forEach { NSLayoutConstraint.activate($0) }
    }
    
    // MARK: - Configure view
    private func configureView() {
        view.addBlur()
        view.addSubview(containerView)
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        
        lineDragView.backgroundColor = .lightGray
        lineDragView.layer.cornerRadius = 2
        
        panGestureView.backgroundColor = .clear
        
        trackImageView.backgroundColor = .black
        
        trackTitleLabel.numberOfLines = 1
        trackTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        trackTitleLabel.textAlignment = .center
        
        artistNameLabel.numberOfLines = 1
        artistNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        artistNameLabel.textAlignment = .center
        
        timePassedLabel.textColor = .gray
        timePassedLabel.numberOfLines = 1
        timePassedLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        timePassedLabel.textAlignment = .center
        
        timeLeftLabel.textColor = .gray
        timeLeftLabel.numberOfLines = 1
        timeLeftLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        timeLeftLabel.textAlignment = .center
        
        [lineDragView, trackImageView, trackTitleLabel, artistNameLabel, trackTimeSlider, timePassedLabel, timeLeftLabel, playPauseButton, panGestureView].forEach { containerView.addSubview($0) }
        
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        trackTimeSlider.addTarget(self, action: #selector(handleTrackTimeSlider), for: .valueChanged)
        
        layoutViews()
        addPanGesture()
    }
    
    // MARK: - GestureRecognizer functions
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGestureView.addGestureRecognizer(panGesture)
        
    }
    
    private func slideViewVerticallyTo(_ y: CGFloat) {
        self.containerView.frame = CGRect(x: 0,
                                          y: y,
                                          width: self.containerView.frame.size.width,
                                          height: self.containerView.frame.size.height)
    }
    
    @objc private func onPan(_ panGesture: UIPanGestureRecognizer) {
        
        let animationDuration: TimeInterval = 0.2
        let touchPoint: CGPoint = panGesture.location(in: self.panGestureView.window)
        let initialHeighPoint: CGFloat = view.frame.size.height - containerView.frame.size.height
        let safeHeight: CGFloat = initialHeighPoint + (initialHeighPoint * 0.5)
        
        switch panGesture.state {
            
        case .changed:
            guard touchPoint.y > initialHeighPoint else { return }
            playPauseButton.setImage(UIImage(named: "play.fill"), for: .normal)
            player.pause()
            slideViewVerticallyTo(touchPoint.y)
            
        case .ended, .cancelled:
            if touchPoint.y > safeHeight {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.containerView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(initialHeighPoint)
                })
            }
            
        default:
            self.containerView.frame.origin = CGPoint(x: 0, y: initialHeighPoint)
        }
    }
    
    // MARK: - AVPlayer functions
    private func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 100)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.timePassedLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 100)) - time).toDisplayString()
            self?.timeLeftLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
            
            guard currentDurationText == "00:00" else { return }
            self?.playPauseButton.setImage(UIImage(named: "play.fill"), for: .normal)
            self?.player.pause()
            self?.player.seek(to: .zero)
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 100))
        let percentage = currentTimeSeconds / durationSeconds
        self.trackTimeSlider.value = Float(percentage)
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        playPauseButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        player.play()
    }
    
    @objc private func playPauseButtonPressed() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play.fill"), for: .normal)
        }
    }
    
    @objc private func handleTrackTimeSlider() {
        let percentage = trackTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 100)
        player.seek(to: seekTime)
    }
    
    deinit {
        print("TrackDetailsViewController memory being reclaimed...")
    }
}

// MARK: - Display logic
extension TrackDetailsViewController: TrackDetailsDisplayLogic {
    
    func displayTrackDetails(viewModel: TrackDetails.ShowTrackDetails.ViewModel) {
        
        let string600 = viewModel.imageURL.replacingOccurrences(of: "100x100", with: "600x600")
        let url = URL(string: string600)
        trackImageView.sd_setImage(with: url)
        
        DispatchQueue.main.async {
            self.trackTitleLabel.text = viewModel.trackName
            self.artistNameLabel.text = viewModel.artistName
            self.playTrack(previewUrl: viewModel.previewUrl)
        }
        
        observePlayerCurrentTime()
    }
    
    func displayAlert(with text: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: text) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
