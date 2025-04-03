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
    tolerance: Duration? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    do {
      try await sleep(for: duration, tolerance: tolerance)
    } catch {
      logWarning(
        """
          Sleep has finished with error: \(ShortDescription(error)) \
          Source: \(file):\(line)
        """,
        file: file,
        line: line
      )
    }
  }
}
