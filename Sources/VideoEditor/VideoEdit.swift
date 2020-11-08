//
//  VideoEdit.swift
//  
//
//  Created by Titouan Van Belle on 13.10.20.
//

import AVFoundation
import Foundation

public struct VideoEdit {
    public var speedRate: Double = 1.0
    public var trimPositions: (CMTime, CMTime)?
    public var croppingPreset: CroppingPreset?
    public var isMuted: Bool = false

    public init() {}
}
