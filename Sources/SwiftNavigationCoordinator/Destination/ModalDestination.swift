//
//  ModalDestination.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import CasePaths

@CasePathable
public enum ModalDestination<DestinationType: Sendable & Hashable & Identifiable>: Sendable, Hashable {
  case cover(DestinationType)
  case sheet(DestinationType)
}

extension ModalDestination {
  public func map<AnotherDestination: Sendable & Hashable & Identifiable>(
    _ transform: (DestinationType) -> AnotherDestination
  ) -> ModalDestination<AnotherDestination> {
    switch self {
    case let .cover(destination): return .cover(transform(destination))
    case let .sheet(destination): return .sheet(transform(destination))
    }
  }
}

extension ModalDestination where DestinationType == AnyIdentifiableDestination {
  public static func == <AnotherDestination: Sendable & Hashable & Identifiable>(
    lhs: Self,
    rhs: ModalDestination<AnotherDestination>
  ) -> Bool {
    switch (lhs, rhs) {
    case let (.cover(lhs), .cover(rhs)): return lhs == rhs
    case let (.sheet(lhs), .sheet(rhs)): return lhs == rhs
    default: return false
    }
  }
  
  public static func == <AnotherDestination: Sendable & Hashable & Identifiable>(
    lhs: ModalDestination<AnotherDestination>,
    rhs: Self
  ) -> Bool {
    switch (lhs, rhs) {
    case let (.cover(lhs), .cover(rhs)): return lhs == rhs
    case let (.sheet(lhs), .sheet(rhs)): return lhs == rhs
    default: return false
    }
  }
}

extension Optional {
  public static func == <AnotherDestination: Sendable & Hashable & Identifiable>(
    lhs: Self,
    rhs: ModalDestination<AnotherDestination>
  ) -> Bool where Self.Wrapped == ModalDestination<AnyIdentifiableDestination>{
    switch (lhs, rhs) {
    case let (.some(.cover(lhs)), .cover(rhs)): return lhs == rhs
    case let (.some(.sheet(lhs)), .sheet(rhs)): return lhs == rhs
    default: return false
    }
  }
  
  public static func == <AnotherDestination: Sendable & Hashable & Identifiable>(
    lhs: ModalDestination<AnotherDestination>,
    rhs: Self
  ) -> Bool where Self.Wrapped == ModalDestination<AnyIdentifiableDestination>{
    switch (lhs, rhs) {
    case let (.cover(lhs), .some(.cover(rhs))): return lhs == rhs
    case let (.sheet(lhs), .some(.sheet(rhs))): return lhs == rhs
    default: return false
    }
  }
}
