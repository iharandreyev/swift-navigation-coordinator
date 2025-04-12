//
//  Environment.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import Clocks

public enum Environment: String {
  case debug
  case release
  case test
}

extension Environment: CustomStringConvertible {
  public var description: String { "`\(rawValue)`" }
}

extension Environment {
  static fileprivate(set) nonisolated(unsafe)
  var current: Environment = .debug
  
  static func setEnvironment(_ newValue: Environment) {
    let oldValue = Environment.current
    
    guard oldValue != newValue else { return }
    
    defer {
      Environment.current = newValue
    }
    
    updateNavigationQueue(oldEnvironment: oldValue, newEnvironment: newValue)
  }
}

// MARK: - Environment + NavigationQueue

extension Environment {
  static fileprivate(set) nonisolated(unsafe)
  var navigationQueue = NavigationQueue(clock: ContinuousClock())
  
  private static func updateNavigationQueue(
    oldEnvironment: Environment,
    newEnvironment: Environment
  ) {
    let isUpdateNeeded = {
      switch (oldEnvironment, newEnvironment) {
      case (_, .test) where oldEnvironment != .test:
        return true
      case (.test, _):
        return true
      default:
        return false
      }
    }()
    
    guard isUpdateNeeded else { return }
    
    navigationQueue = NavigationQueue.for(newEnvironment)
  }
}

// MARK: Environment + Assert

extension Environment {
  @inline(__always)
  static func assert(
    _ expectedEnvironment: Environment,
    function: StaticString = #function
  ) {
    #warning("TODO: Look for a better solution since this code adds likely unnecessary overhead")
    Swift.assert(
      current == expectedEnvironment,
      "\(function) can't be executed in environment \(current). Make sure the environment is set properly"
    )
  }
}
