//
//  Logger.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

final class Logger: LoggerType {
  private var external: LoggerType?

  @inline(__always)
  func logWarning(_ message: @autoclosure () -> String) {
    external?.logWarning(message())
  }
  
  @inline(__always)
  func logMessage(_ message: @autoclosure () -> String) {
    external?.logMessage(message())
  }
}

extension Logger {
  nonisolated(unsafe)
  fileprivate static let shared = Logger()
  
  static func setLogger(_ logger: LoggerType) {
    Logger.shared.external = logger
  }
}

@inline(__always)
func logWarning(_ message: @autoclosure () -> String) {
  Logger.shared.logWarning(message())
}

@inline(__always)
func logWarning(
  _ message: @autoclosure () -> String,
  file: StaticString,
  line: UInt
) {
  Logger.shared.logWarning(
    """
      \(message()).             \
      Source: \(file):\(line)
    """
  )
}

@inline(__always)
func logMessage(_ message: @autoclosure () -> String) {
  Logger.shared.logMessage(message())
}
