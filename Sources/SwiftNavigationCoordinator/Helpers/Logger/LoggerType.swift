//
//  LoggerType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol LoggerType {
  func logWarning(_ message: @autoclosure () -> String)
  func logMessage(_ message: @autoclosure () -> String)
}
