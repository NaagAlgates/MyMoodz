//
//  Item.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
