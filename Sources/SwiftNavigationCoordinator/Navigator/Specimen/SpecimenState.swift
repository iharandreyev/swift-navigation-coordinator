//
//  SpecimenState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import SwiftUI

@MainActor
@Perceptible
final class SpecimenState {
  fileprivate(set) var _destination: AnyIdentifiableDestination

  init<Destination: Sendable & Hashable & Identifiable>(
    initialDestination: Destination
  ) {
    _destination = AnyIdentifiableDestination(initialDestination)
  }

  convenience init() {
    self.init(initialDestination: DestinationNever())
  }
  
  func setDestination<Destination: Sendable & Hashable & Identifiable>(
    _ newValue: Destination,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    CheckNever: if _destination.wrapped is DestinationNever {
      break CheckNever
    } else {
      guard assert(
        _destination.wrapped,
        is: Destination.self,
        sourceFile: sourceFile,
        line: line
      ) else {
        return
      }
    }
    
    let newValue = AnyIdentifiableDestination(newValue)
    guard _destination != newValue else { return }
    _destination = newValue
  }
}

extension SpecimenState {
  @MainActor
  func destination<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Destination {
    cast(_destination.wrapped, sourceFile: sourceFile, line: line)
  }
}

extension Perception.Bindable where Value == SpecimenState {
  @MainActor
  func destination<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Binding<Destination> {
    Binding(
      get: { [unowned wrappedValue] in
        wrappedValue.destination(for: destinationType, sourceFile: sourceFile, line: line)
      },
      set: { [unowned wrappedValue] newValue in
        wrappedValue.setDestination(newValue)
      }
    )
  }
}
