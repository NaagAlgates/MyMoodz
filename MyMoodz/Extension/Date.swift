//
//  Date.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 13/4/2025.
//

import SwiftUI

extension Date {
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
}
