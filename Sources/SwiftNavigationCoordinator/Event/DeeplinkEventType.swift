//
//  DeeplinkEventType.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol DeeplinkEventType: Sendable { }

public enum ProcessDeeplinkResult {
  case impossible
  case partial
  case done
}
