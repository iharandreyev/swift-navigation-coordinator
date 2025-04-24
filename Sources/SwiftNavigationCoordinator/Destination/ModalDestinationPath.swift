//
//  ModalDestinationPath.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import CasePaths

@CasePathable
public enum ModalDestinationPath<Destination: Sendable & Hashable & Identifiable>: Sendable, Hashable {
  case cover(Destination)
  case sheet(Destination)
}

extension ModalDestinationPath {
  public var value: Destination {
    switch self {
    case let .cover(destination): return destination
    case let .sheet(destination): return destination
    }
  }
  
  public func map<AnotherDestination>(_ transform: (Destination) -> AnotherDestination) -> ModalDestinationPath<AnotherDestination> {
    switch self {
    case let .cover(destination): return .cover(transform(destination))
    case let .sheet(destination): return .sheet(transform(destination))
    }
  }
}
