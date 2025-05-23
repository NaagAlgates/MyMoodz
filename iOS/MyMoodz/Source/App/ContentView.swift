//
//  ContentView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/5/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > 700 {
                IPadHomeScreen()
            } else {
                MobileHomeScreen()
            }
        }
    }
}
