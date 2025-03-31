//
//  LoggerType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol LoggerType {
  func logWarning(_ message: @autoclosure () -> Any)
  func logMessage(_ message: @autoclosure () -> Any)
}
