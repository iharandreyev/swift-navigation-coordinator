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
  fileprivate(set) var _destination: ModalDestination<AnyIdentifiableDestination>?
  
  @PerceptionIgnored
  private var delegates: [ObjectIdentifier: AnyModalStateDelegate] = [:]

  init<Destination: Sendable & Hashable & Identifiable>(
    initialDestination: ModalDestination<Destination>?
  ) {
    _destination = initialDestination?.map(AnyIdentifiableDestination.init)
  }
  
  init() {
    _destination = nil
  }
  
  func setDestination<Destination: Sendable & Hashable & Identifiable>(
    _ modalDestination: ModalDestination<Destination>,
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
    _ newValue: ModalDestination<Destination>?,
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
  func destination<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Binding<ModalDestination<Destination>?> {
    Binding<ModalDestination<Destination>?>(
      get: { [unowned wrappedValue] () -> ModalDestination<Destination>? in
        wrappedValue.destination(for: destinationType, sourceFile: sourceFile, line: line)
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue, sourceFile: sourceFile, line: line)
      }
    )
  }
}

extension ModalState {
  func destination<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> ModalDestination<Destination>? {
    _destination.map { destination in
      destination.map { value in
        cast(value.wrapped, sourceFile: sourceFile, line: line)
      }
    }
  }
}

@MainActor
protocol ModalStateDelegate: AnyObject {
  func modalStateDidDismiss(_ destination: AnyIdentifiableDestination)
}

extension ModalStateDelegate {
  @_disfavoredOverload
  func eraseToAnyModalStateDelegate() -> AnyModalStateDelegate {
    AnyModalStateDelegate(self)
  }
  
  func eraseToAnyNavigationQueue() -> AnyModalStateDelegate where Self == AnyModalStateDelegate {
    self
  }
}

@MainActor
final class AnyModalStateDelegate: ModalStateDelegate {
  private var _modalStateDidDismiss: ((AnyIdentifiableDestination) -> Void)!
  
  private(set) var isValid = true
  
  init<Delegate: ModalStateDelegate>(
    _ delegate: Delegate
  ) {
    assert(Delegate.self != AnyModalStateDelegate.self)
    
    _modalStateDidDismiss = { [weak self, weak delegate] in
      guard let delegate else {
        self?.isValid = false
        return
      }
      
      delegate.modalStateDidDismiss($0)
    }
  }
  
  func modalStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    _modalStateDidDismiss(destination)
  }
}
