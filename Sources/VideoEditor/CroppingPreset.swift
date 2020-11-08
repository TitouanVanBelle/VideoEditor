//
//  CroppingPreset.swift
//  
//
//  Created by Titouan Van Belle on 14.10.20.
//

import Foundation

public enum CroppingPreset: CaseIterable {
    case vertical // 3:4
    case standard // 4:3
    case portrait // 9:16
    case square // 1:1
    case landscape // 16:9
    case instagram // 4:5

    var widthToHeightRatio: Double {
        switch self {
        case .vertical:
            return 3 / 4
        case .standard:
            return 4 / 3
        case .portrait:
            return 9 / 16
        case .square:
            return 1 / 1
        case .landscape:
            return 16 / 9
        case .instagram:
            return 4 / 5
        }
    }
}
