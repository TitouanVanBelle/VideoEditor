//
//  ViewController.swift
//  VideoEditorDemo
//
//  Created by Titouan Van Belle on 13.10.20.
//

import AVKit
import Combine
import PureLayout
import UIKit
import VideoEditor

class ViewController: UIViewController {

    private lazy var originalPlayerViewController: AVPlayerViewController = makeOriginalPlayerController()
    private lazy var editPlayerViewController: AVPlayerViewController = makeEditedPlayerController()
    private lazy var exportButton: UIButton = makeExportButton()

    private lazy var originalPlayer: AVPlayer = makeOriginalPlayer()
    private lazy var editPlayer: AVPlayer = makeEditPlayer()
    private lazy var editor: VideoEditor = VideoEditor()
    private lazy var videoEdit: VideoEdit = makeVideoEdit()
    private lazy var asset: AVAsset = makeAsset()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        originalPlayerViewController.player = originalPlayer
        editPlayerViewController.player = editPlayer

        editor.apply(edit: videoEdit, to: asset)
            .map { result -> AVPlayerItem? in
                let item = AVPlayerItem(asset: result.asset)
                item.videoComposition = result.videoComposition
                return item
            }
            .replaceError(with: nil)
            .sink { [weak self] item in
                self?.editPlayer.replaceCurrentItem(with: item)
            }
            .store(in: &cancellables)
    }
}

// MARK: UI

fileprivate extension ViewController {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        add(originalPlayerViewController)
        add(editPlayerViewController)
        view.addSubview(exportButton)
    }

    func setupConstraints() {
        originalPlayerViewController.view.autoPinEdge(toSuperviewSafeArea: .top)
        originalPlayerViewController.view.autoPinEdge(toSuperviewEdge: .right)
        originalPlayerViewController.view.autoPinEdge(toSuperviewEdge: .left)

        editPlayerViewController.view.autoPinEdge(toSuperviewEdge: .right)
        editPlayerViewController.view.autoPinEdge(toSuperviewEdge: .left)
        editPlayerViewController.view.autoPinEdge(.top, to: .bottom, of: originalPlayerViewController.view)
        editPlayerViewController.view.autoPinEdge(.bottom, to: .top, of: exportButton)
        editPlayerViewController.view.autoMatch(.height, to: .height, of: originalPlayerViewController.view)

        exportButton.autoSetDimension(.height, toSize: 60.0)
        exportButton.autoPinEdge(toSuperviewEdge: .right)
        exportButton.autoPinEdge(toSuperviewEdge: .left)
        exportButton.autoPinEdge(toSuperviewSafeArea: .bottom)
    }

    func makeOriginalPlayerController() -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        return controller
    }

    func makeEditedPlayerController() -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        return controller
    }

    func makeOriginalPlayer() -> AVPlayer {
        let url = Bundle.main.url(forResource: "HongKong", withExtension: "mp4")!
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)

        return AVPlayer(playerItem: item)
    }

    func makeVideoEdit() -> VideoEdit {
        var edit = VideoEdit()
        edit.isMuted = false
        edit.speedRate = 2.0
        edit.croppingPreset = .square
        edit.trimPositions = (
            CMTime(value: 2, timescale: 1),
            CMTime(value: 6, timescale: 1)
        )
        return edit
    }

    func makeAsset() -> AVAsset {
        let url = Bundle.main.url(forResource: "HongKong", withExtension: "mp4")!
        return AVAsset(url: url)
    }

    func makeEditPlayer() -> AVPlayer {
        AVPlayer()
    }

    func makeExportButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Export", for: .normal)
        button.addTarget(self, action: #selector(export), for: .touchUpInside)
        return button
    }
}

// MARK: Actions

fileprivate extension ViewController {
    @objc func export() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let outputUrl = documentsDirectory.appendingPathComponent("HongKong-Edited.mp4")

        try? FileManager.default.removeItem(atPath: outputUrl.path)

        editor.apply(edit: videoEdit, to: asset)
            .flatMap { result in
                result.export(to: outputUrl)
            }.sink { result in
                print("Failed to save edited video at \(outputUrl.path). Error: \(result)")
            } receiveValue: { _ in
                print("Successfully saved edited video at \(outputUrl.path)")
            }
            .store(in: &cancellables)
    }
}

extension UIViewController {
    func add(_ controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
