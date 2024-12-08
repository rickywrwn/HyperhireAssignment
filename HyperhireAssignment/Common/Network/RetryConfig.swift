//
//  RetryConfig.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 08/12/24.
//

import Foundation

struct RetryConfig {
    let maxAttempts: Int
    let initialDelay: TimeInterval
    let maxDelay: TimeInterval
    let multiplier: Double
    
    static let `default` = RetryConfig(
        maxAttempts: 3,
        initialDelay: 1.0,
        maxDelay: 5.0,
        multiplier: 2.0
    )
}
