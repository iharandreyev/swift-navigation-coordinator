//
//  LoggerType.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol LoggerType {
  func logError(_ message: Any)
  func logWarning(_ message: Any)
  func logInfo(_ message: Any)
  func logMessage(_ message: Any)
}
