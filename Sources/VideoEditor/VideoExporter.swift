//
//  VideoExporter.swift
//  
//
//  Created by Titouan Van Belle on 08.11.20.
//

// TODO:
// - Make sur export is possible based on extension

import AVFoundation
import Combine
import Foundation

protocol VideoExporterProtocol {
    func export(asset: AVAsset, to url: URL, videoComposition: AVVideoComposition?) -> AnyPublisher<Void, Error>
}

final class VideoExporter: VideoExporterProtocol {
    func export(asset: AVAsset, to url: URL, videoComposition: AVVideoComposition?) -> AnyPublisher<Void, Error> {
        Future { promise in
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
            exporter?.outputURL = url
            exporter?.outputFileType = .mp4
            exporter?.videoComposition = videoComposition

            exporter?.exportAsynchronously(completionHandler: {
                if let error = exporter?.error {
                    promise(.failure(error))
                    return
                }

                promise(.success(()))
            })
        }.eraseToAnyPublisher()

    }
}
