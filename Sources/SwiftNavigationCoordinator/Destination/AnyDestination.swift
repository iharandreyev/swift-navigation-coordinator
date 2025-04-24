//
//  AnyDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections

#warning("TODO: Documentation")
public struct AnyDestination: SomeDestination {
  internal let wrapped: Sendable

  private let getId: @Sendable () -> String
  private let equateTo: @Sendable (Self) -> Bool
  private let hashInto: @Sendable (inout Hasher) -> Void

  public init<Destination: SomeDestination>(_ destination: Destination) {
    switch destination {
    case let another as Self:
      self = another
    default:
      self.init(destination: destination)
    }
  }

  private init<Destination: SomeDestination>(destination: Destination) {
    wrapped = destination
    
    getId = {
      "\(destination.id)"
    }

    equateTo = { rhs in
      guard let rhs = rhs.wrapped as? Destination else { return false }
      return rhs == destination
    }

    hashInto = { hasher in
      hasher.combine(destination)
    }
  }

  public var id: String {
    getId()
  }

  public func hash(into hasher: inout Hasher) {
    hashInto(&hasher)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.equateTo(rhs)
  }
}

extension AnyDestination: CustomStringConvertible {
  public var description: String {
    "Erased(\(ShortDescription(wrapped)))"
  }
}

extension AnyDestination {
  public static func == <Destination: SomeDestination>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    let result = lhs == AnyDestination(rhs)
    return result
  }
}

extension Optional where Wrapped == AnyDestination {
  public static func == <Destination: SomeDestination>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    switch lhs {
    case .none:
      return false
    case let .some(lhs):
      let result = lhs == rhs
      return result
    }
  }
}

extension Array where Element == AnyDestination {
  public static func == <Destination: SomeDestination>(
    lhs: Self,
    rhs: [Destination]
  ) -> Bool {
    guard lhs.count == rhs.count else {
      return false
    }
    
    for (lhs, rhs) in zip(lhs, rhs) {
      guard lhs == rhs else {
        return false
      }
    }
    
    return true
  }
}

extension OrderedSet where Element == AnyDestination {
  public static func == <Destination: SomeDestination>(
    lhs: Self,
    rhs: OrderedSet<Destination>
  ) -> Bool {
    guard lhs.count == rhs.count else {
      return false
    }
    
    for (lhs, rhs) in zip(lhs, rhs) {
      guard lhs == rhs else {
        return false
      }
    }
    
    return true
  }
}

extension Array where Element: DestinationType {
  public func erase() -> Array<AnyDestination> {
    map(AnyDestination.init)
  }
}

extension OrderedSet where Element: DestinationType {
  public func erase() -> OrderedSet<AnyDestination> {
    OrderedSet<AnyDestination>(map(AnyDestination.init))
  }
}
