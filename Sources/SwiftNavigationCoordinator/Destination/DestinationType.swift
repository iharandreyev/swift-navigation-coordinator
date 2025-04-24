//
//  DestinationType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

public protocol DestinationType: SomeDestination { }

public extension DestinationType where Self: RawRepresentable, RawValue: Hashable {
  var id: RawValue {
    rawValue
  }
}

public typealias SomeDestination = Sendable & Hashable & Identifiable
