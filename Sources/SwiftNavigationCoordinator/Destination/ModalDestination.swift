//
//  ModalDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import CasePaths

@CasePathable
public enum ModalDestination<Destination: Sendable & Hashable & Identifiable>: Sendable, Hashable {
  case cover(Destination)
  case sheet(Destination)
}

extension ModalDestination {
  public var value: Destination {
    switch self {
    case let .cover(destination): return destination
    case let .sheet(destination): return destination
    }
  }
  
  public func map<AnotherDestination>(_ transform: (Destination) -> AnotherDestination) -> ModalDestination<AnotherDestination> {
    switch self {
    case let .cover(destination): return .cover(transform(destination))
    case let .sheet(destination): return .sheet(transform(destination))
    }
  }
}
