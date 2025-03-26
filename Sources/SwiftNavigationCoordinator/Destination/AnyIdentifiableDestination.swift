//
//  AnyIdentifiableDestination.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public struct AnyIdentifiableDestination: Sendable {
  internal let wrapped: Sendable

  private let getId: @Sendable () -> String
  private let equateTo: @Sendable (Self) -> Bool
  private let hashInto: @Sendable (inout Hasher) -> Void

  public init<Destination: Sendable & Identifiable & Hashable>(_ destination: Destination) {
    switch destination {
    case let another as Self:
      self = another
    default:
      self.init(destination: destination)
    }
  }

  private init<Destination: Sendable & Identifiable & Hashable>(destination: Destination) {
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

extension AnyIdentifiableDestination {
  public static func == <Destination: Sendable & Identifiable & Hashable>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    lhs == AnyIdentifiableDestination(rhs)
  }
  
  public static func == <Destination: Sendable & Identifiable & Hashable>(
    lhs: Destination,
    rhs: Self
  ) -> Bool {
    AnyIdentifiableDestination(lhs) == rhs
  }
}

extension Optional where Wrapped == AnyIdentifiableDestination {
  public static func == <Destination: Sendable & Hashable>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    switch lhs {
    case .none: return false
    case let .some(lhs): return lhs == rhs
    }
  }
  
  public static func == <Destination: Sendable & Hashable>(
    lhs: Destination,
    rhs: Self
  ) -> Bool {
    switch rhs {
    case .none: return false
    case let .some(rhs): return lhs == rhs
    }
  }
}

extension AnyIdentifiableDestination {
  func extract<T>(
    type: T.Type = T.self
  ) -> T? {
    wrapped as? T
  }
}
