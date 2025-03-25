//
//  Logger.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

final class Logger: LoggerType {
  fileprivate var external: LoggerType?

  @inline(__always)
  func logWarning(_ message: Any) {
    external?.logWarning(message)
  }
  
  @inline(__always)
  func logMessage(_ message: Any) {
    external?.logMessage(message)
  }
}

extension Logger {
  nonisolated(unsafe) static let shared = Logger()
  
  func setLogger(_ logger: LoggerType) {
    external = logger
  }
}

@inline(__always)
func logWarning(_ message: Any) {
  Logger.shared.logWarning(message)
}

@inline(__always)
func logMessage(_ message: Any) {
  Logger.shared.logMessage(message)
}
