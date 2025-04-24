//
//  SwiftNavigationCoordinator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public func setLogger(_ logger: LoggerType) {
  Logger.setLogger(logger)
}

public func setEnvironment(_ newValue: Environment) {
  Environment.setEnvironment(newValue)
}
