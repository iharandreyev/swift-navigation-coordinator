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
  fileprivate(set) var _destination: AnyDestination

  init<Destination: SomeDestination>(
    initialDestination: Destination
  ) {
    _destination = AnyDestination(initialDestination)
  }

  convenience init() {
    self.init(initialDestination: DestinationNever())
  }
  
  func setDestination<Destination: SomeDestination>(
    _ newValue: Destination,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    CheckNever: if _destination.wrapped is DestinationNever {
      break CheckNever
    } else {
      guard assert(
        _destination.wrapped,
        is: Destination.self,
        invokedIn: file,
        at: line
      ) else {
        return
      }
    }
    
    let newValue = AnyDestination(newValue)
    guard _destination != newValue else { return }
    _destination = newValue
  }
}

extension SpecimenState {
  @MainActor
  func destination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Destination {
    cast(_destination.wrapped, invokedIn: file, at: line)
  }
}

extension Perception.Bindable where Value == SpecimenState {
  @MainActor
  func destination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Binding<Destination> {
    Binding(
      get: { [unowned wrappedValue] in
        wrappedValue.destination(for: destinationType, invokedIn: file, at: line)
      },
      set: { [unowned wrappedValue] newValue in
        wrappedValue.setDestination(newValue)
      }
    )
  }
}
