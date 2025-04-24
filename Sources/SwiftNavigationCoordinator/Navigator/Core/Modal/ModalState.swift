//
//  ModalState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import SwiftUI

@MainActor
@Perceptible
final class ModalState {
  fileprivate(set) var _destination: ModalDestinationPath<AnyDestination>?
  
  @PerceptionIgnored
  fileprivate(set) var delegates: [ObjectIdentifier: AnyModalStateDelegate] = [:]

  init<Destination: SomeDestination>(
    initialDestination: ModalDestinationPath<Destination>?
  ) {
    _destination = initialDestination?.map(AnyDestination.init)
  }
  
  init() {
    _destination = nil
  }
  
  func setDestination<Destination: SomeDestination>(
    _ modalDestination: ModalDestinationPath<Destination>,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    guard assert(
      modalDestination.value,
      is: Destination.self,
      invokedIn: file,
      at: line
    ) else {
      return
    }
    
    let newValue = modalDestination.map(AnyDestination.init)
    guard _destination != newValue else { return }
    _destination = newValue
  }
  
  fileprivate func setBoundDestination<Destination: SomeDestination>(
    _ newValue: ModalDestinationPath<Destination>?,
    invokedIn file: StaticString,
    at line: UInt
  ) {
    if let destination = newValue {
      return logWarning(
        "SwiftUI is trying to set \(destination) as modal state, which is forbidden",
        invokedIn: file,
        at: line
      )
    }
    
    let dismissedDestination = _destination
    
    dismissDestination()
    
    guard let dismissedDestination else { return }
    
    reportDismiss(of: dismissedDestination.value)
  }
  
  func dismissDestination() {
    _destination = nil
  }
  
  func appendDelegate<Delegate: ModalStateDelegate>(_ delegate: Delegate) {
    delegates[ObjectIdentifier(delegate)] = delegate.eraseToAnyModalStateDelegate()
  }
  
  private func reportDismiss(of destination: AnyDestination) {
    for (id, delegate) in delegates {
      delegate.modalStateDidDismiss(destination)
      
      if !delegate.isValid {
        delegates.removeValue(forKey: id)
      }
    }
  }
}

extension Perception.Bindable where Value == ModalState {
  @MainActor
  func destination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Binding<ModalDestinationPath<Destination>?> {
    Binding<ModalDestinationPath<Destination>?>(
      get: { [unowned wrappedValue] () -> ModalDestinationPath<Destination>? in
        wrappedValue.destination(for: destinationType, invokedIn: file, at: line)
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue, invokedIn: file, at: line)
      }
    )
  }
}

extension ModalState {
  @MainActor
  func destination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> ModalDestinationPath<Destination>? {
    _destination.map { destination in
      destination.map { value in
        cast(value.wrapped, invokedIn: file, at: line)
      }
    }
  }
}
