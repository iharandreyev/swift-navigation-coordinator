//
//  AnyDestination.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public struct AnyDestination: Sendable {
  internal let wrapped: Sendable

  private let equateTo: @Sendable (Self) -> Bool
  private let hashInto: @Sendable (inout Hasher) -> Void

  public init<Destination: Sendable & Hashable>(_ destination: Destination) {
    switch destination {
    case let another as Self:
      self = another
    default:
      self.init(destination: destination)
    }
  }

  private init<Destination: Sendable & Hashable>(destination: Destination) {
    wrapped = destination

    equateTo = { rhs in
      guard let rhs = rhs.wrapped as? Destination else { return false }
      return rhs == destination
    }

    hashInto = { hasher in
      hasher.combine(destination)
    }
  }
}

extension AnyDestination: Hashable {
  public func hash(into hasher: inout Hasher) {
    hashInto(&hasher)
  }
}

extension AnyDestination: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.equateTo(rhs)
  }
}

extension AnyDestination {
  public static func == <Destination: Sendable & Hashable>(
    lhs: Self,
    rhs: Destination
  ) -> Bool {
    lhs == AnyDestination(rhs)
  }
  
  public static func == <Destination: Sendable & Hashable>(
    lhs: Destination,
    rhs: Self
  ) -> Bool {
    AnyDestination(lhs) == rhs
  }
}

extension Optional where Wrapped == AnyDestination {
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

extension AnyDestination {
  func extract<T>(
    type: T.Type = T.self
  ) -> T? {
    wrapped as? T
  }
}
