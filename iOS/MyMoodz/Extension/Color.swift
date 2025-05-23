//
//  Color.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/4/2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // optional "#"

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
    
    func isDark(in scheme: ColorScheme) -> Bool {
            let uiColor = UIColor(self)
            var white: CGFloat = 0
            uiColor.getWhite(&white, alpha: nil)
            return scheme == .dark && white < 0.2
        }
}
