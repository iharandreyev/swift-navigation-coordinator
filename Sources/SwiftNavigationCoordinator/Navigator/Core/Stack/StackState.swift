//
//  StackState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import OrderedCollections
import Perception
import SwiftUI

@MainActor
@Perceptible
final class StackState {
  fileprivate(set) var _path: SwiftUI.NavigationPath
  
  @PerceptionIgnored
  fileprivate(set) var _stack: OrderedSet<AnyDestination>

  @PerceptionIgnored
  private var delegates: [ObjectIdentifier: AnyStackStateDelegate] = [:]
  
  init(
    initialStack: OrderedSet<AnyDestination> = [],
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    _stack = initialStack
    _path = SwiftUI.NavigationPath()
    
    for destination in initialStack {
      _path.append(destination)
    }
  }
  
  /// A Boolean that indicates whether this _stack is empty.
  @PerceptionIgnored
  var isEmpty: Bool {
    _path.isEmpty
  }
  
  /// The number of elements in this _stack.
  @PerceptionIgnored
  var count: Int {
    _path.count
  }
  
  /// Appends a new destination value to the end of this _stack.
  func append<Destination: SomeDestination>(
    _ destination: Destination,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    let entry = AnyDestination(destination)
    guard !_stack.contains(entry) else {
      return logWarning(
        """
          Trying to append \(ShortDescription(destination)), which is already present in the stack  \
          Ignoring `append`
        """,
        invokedIn: file,
        at: line
      )
    }

    _path.append(destination)
    _stack.append(entry)
  }
  /// Removes values from the end of this _stack.
  func removeLast(
    _ numOfItemsToRemove: Int = 1,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    guard numOfItemsToRemove > 0 else {
      return logWarning(
        """
          Trying to remove last entry from an empty stack  \
          Ignoring `removeLast`
        """,
        invokedIn: file,
        at: line
      )
    }

    _path.removeLast(numOfItemsToRemove)
    _stack.removeLast(numOfItemsToRemove)
  }
  
  func index<Destination: SomeDestination>(
    of destination: Destination
  ) -> Int? {
    _stack.firstIndex(of: AnyDestination(destination))
  }
  
  func removeAll(
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    guard !isEmpty else {
      return logWarning(
        """
          Trying to remove all entries from an empty stack  \
          Ignoring `removeAll`
        """,
        invokedIn: file,
        at: line
      )
    }

    let numOfItemsToRemove = count
    
    _path.removeLast(numOfItemsToRemove)
    _stack.removeLast(numOfItemsToRemove)
  }
  
  fileprivate func setBoundPath(
    _ newValue: SwiftUI.NavigationPath,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    let dismissedDestination: AnyDestination
    
    switch (newValue.count - _path.count) {
    case 0:
      return
      
    case -1:
      dismissedDestination = _stack.removeLast()
      
    default:
      fatalError(
        "Invalid path update from count `\(_path.count)` to \(newValue.count).",
        invokedIn: file,
        at: line
      )
    }

    _path = newValue
    
    reportDismiss(of: dismissedDestination)
  }
  
  func appendDelegate<Delegate: StackStateDelegate>(_ delegate: Delegate) {
    delegates[ObjectIdentifier(delegate)] = delegate.eraseToAnyStackStateDelegate()
  }
  
  private func reportDismiss(of destination: AnyDestination) {
    for (id, delegate) in delegates {
      delegate.stackStateDidDismiss(destination)
      
      if !delegate.isValid {
        delegates.removeValue(forKey: id)
      }
    }
  }
}

extension Perception.Bindable where Value == StackState {
  @MainActor
  func path(
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Binding<SwiftUI.NavigationPath> {
    Binding<SwiftUI.NavigationPath>(
      get: { [unowned wrappedValue] () -> SwiftUI.NavigationPath in
        wrappedValue._path
      },
      set: { [unowned wrappedValue] (updatedPath) in
        wrappedValue.setBoundPath(
          updatedPath,
          invokedIn: file,
          at: line
        )
      }
    )
  }
}

extension StackState {
  @MainActor
  @inline(__always)
  func stack() -> [AnyDestination] {
    _stack.elements
  }
}
