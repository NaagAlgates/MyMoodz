//
//  Log.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import Foundation

enum AppEnvironment: String {
    case development = "DEVELOPMENT"
    case unknown
}

struct Log {
    static let currentEnv: AppEnvironment = {
        let value = Bundle.main.infoDictionary?["APP_ENV"] as? String
        return AppEnvironment(rawValue: value ?? "") ?? .unknown
    }()

    static func d(_ message: Any...) {
        guard currentEnv == .development else { return }
        print("🧪 [DEV LOG]", message.map { "\($0)" }.joined(separator: " "))
    }
}
