//
//  VideoEditResult.swift
//  
//
//  Created by Titouan Van Belle on 08.11.20.
//

import AVFoundation
import Combine

public struct VideoEditResult {
    public let asset: AVAsset
    public let videoComposition: AVVideoComposition

    private let exporter: VideoExporterProtocol

    init(
        asset: AVAsset,
        videoComposition: AVVideoComposition,
        exporter: VideoExporterProtocol = VideoExporter()
    ) {
        self.asset = asset
        self.videoComposition = videoComposition
        self.exporter = exporter
    }

    public func export(to outputUrl: URL) -> AnyPublisher<Void, Error> {
        exporter.export(asset: asset, to: outputUrl, videoComposition: videoComposition)
    }
}
