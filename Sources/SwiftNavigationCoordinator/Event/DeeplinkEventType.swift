//
//  DeeplinkEventType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol DeeplinkEventType: Sendable { }

public enum ProcessDeeplinkResult: Sendable {
  case impossible
  case partial
  case done
}
