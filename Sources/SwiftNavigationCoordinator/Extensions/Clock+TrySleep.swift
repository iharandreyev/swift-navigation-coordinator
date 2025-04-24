//
//  Clock+TrySleep.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import Foundation

extension Clock {
  /// Attempts to sleep, and prints a warning if the task has been cancelled for some reason
  func trySleep(
    for duration: Duration,
    tolerance: Duration? = nil
  ) async {
    do {
      try await sleep(for: duration, tolerance: tolerance)
    } catch {
      return
    }
  }
}
