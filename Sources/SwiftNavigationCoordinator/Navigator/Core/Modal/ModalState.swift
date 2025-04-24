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
  fileprivate(set) var _destination: ModalDestinationPath<AnyIdentifiableDestination>?
  
  @PerceptionIgnored
  fileprivate(set) var delegates: [ObjectIdentifier: AnyModalStateDelegate] = [:]

  init<Destination: Sendable & Hashable & Identifiable>(
    initialDestination: ModalDestinationPath<Destination>?
  ) {
    _destination = initialDestination?.map(AnyIdentifiableDestination.init)
  }
  
  init() {
    _destination = nil
  }
  
  func setDestination<Destination: Sendable & Hashable & Identifiable>(
    _ modalDestination: ModalDestinationPath<Destination>,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    guard assert(
      modalDestination.value,
      is: Destination.self,
      sourceFile: sourceFile,
      line: line
    ) else {
      return
    }
    
    let newValue = modalDestination.map(AnyIdentifiableDestination.init)
    guard _destination != newValue else { return }
    _destination = newValue
  }
  
  fileprivate func setBoundDestination<Destination: Sendable & Hashable & Identifiable>(
    _ newValue: ModalDestinationPath<Destination>?,
    sourceFile: StaticString,
    line: UInt
  ) {
    if let destination = newValue {
      return logWarning(
        "SwiftUI is trying to set \(destination) as modal state, which is forbidden",
        file: sourceFile,
        line: line
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
  
  private func reportDismiss(of destination: AnyIdentifiableDestination) {
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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Binding<ModalDestinationPath<Destination>?> {
    Binding<ModalDestinationPath<Destination>?>(
      get: { [unowned wrappedValue] () -> ModalDestinationPath<Destination>? in
        wrappedValue.destination(for: destinationType, sourceFile: sourceFile, line: line)
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue, sourceFile: sourceFile, line: line)
      }
    )
  }
}

extension ModalState {
  @MainActor
  func destination<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> ModalDestinationPath<Destination>? {
    _destination.map { destination in
      destination.map { value in
        cast(value.wrapped, sourceFile: sourceFile, line: line)
      }
    }
  }
}
