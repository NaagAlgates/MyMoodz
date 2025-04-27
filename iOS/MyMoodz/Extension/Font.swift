//
//  Font.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

extension Font {
    static func sfRounded(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String

        switch weight {
        case .bold:
            name = "SFProRounded-Bold"
        case .semibold:
            name = "SFProRounded-Semibold"
        default:
            name = "SFProRounded-Regular"
        }

        return .custom(name, size: size)
    }
}
