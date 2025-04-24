//
//  AnyIdentifiableDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

public struct AnyIdentifiableDestination: Sendable {
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
}

extension AnyIdentifiableDestination: Identifiable {
  public var id: String {
    getId()
  }
}

extension AnyIdentifiableDestination: Hashable {
  public func hash(into hasher: inout Hasher) {
    hashInto(&hasher)
  }
}

extension AnyIdentifiableDestination: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.equateTo(rhs)
  }
}

extension AnyIdentifiableDestination: CustomStringConvertible {
  public var description: String {
    "Erased(\(ShortDescription(wrapped)))"
  }
}

extension AnyIdentifiableDestination {
  public static func == <Destination: SomeDestination>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    let result = lhs == AnyIdentifiableDestination(rhs)
    return result
  }
}

extension Optional where Wrapped == AnyIdentifiableDestination {
  public static func == <Destination: Sendable & Hashable & Identifiable>(
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

extension Array where Element == AnyIdentifiableDestination {
  public static func == <Destination: Sendable & Hashable & Identifiable>(
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
