//
//  Logger.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator

final class Logger {
  nonisolated(unsafe)
  static let shared = Logger()
  
  private init () {}
}

extension Logger: SwiftNavigationCoordinator.LoggerType {
  @inline(__always)
  func logWarning(
    _ message: @autoclosure () -> String
  ) {
    print(LogMessageWarning(content: message()).description)
  }
  
  @inline(__always)
  func logMessage(
    _ message: @autoclosure () -> String
  ) {
    print(LogMessageMessage(content: message()).description)
  }
}

@inline(__always)
func logWarning(_ message: @autoclosure () -> String) {
  Logger.shared.logWarning(message())
}

@inline(__always)
func logMessage(_ message: @autoclosure () -> String) {
  Logger.shared.logMessage(message())
}
