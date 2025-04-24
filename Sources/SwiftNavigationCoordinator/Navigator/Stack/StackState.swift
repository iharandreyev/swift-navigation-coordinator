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
  fileprivate(set) var _stack: OrderedSet<AnyIdentifiableDestination>

  @PerceptionIgnored
  private var delegates: [ObjectIdentifier: AnyStackStateDelegate] = [:]
  
  init(
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    _path = SwiftUI.NavigationPath()
    _stack = []
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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    let entry = AnyIdentifiableDestination(destination)
    guard !_stack.contains(entry) else {
      return logWarning(
        """
          Trying to append \(ShortDescription(destination)), which is already present in the stack  \
          Ignoring `append`
        """,
        file: sourceFile,
        line: line
      )
    }

    _path.append(destination)
    _stack.append(entry)
  }
  /// Removes values from the end of this _stack.
  func removeLast(
    _ numOfItemsToRemove: Int = 1,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    guard numOfItemsToRemove > 0 else {
      return logWarning(
        """
          Trying to remove last entry from an empty stack  \
          Ignoring `removeLast`
        """,
        file: sourceFile,
        line: line
      )
    }

    _path.removeLast(numOfItemsToRemove)
    _stack.removeLast(numOfItemsToRemove)
  }
  
  func index<Destination: SomeDestination>(
    of destination: Destination
  ) -> Int? {
    _stack.firstIndex(of: AnyIdentifiableDestination(destination))
  }
  
  func removeAll(
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    guard !isEmpty else {
      return logWarning(
        """
          Trying to remove all entries from an empty stack  \
          Ignoring `removeAll`
        """,
        file: sourceFile,
        line: line
      )
    }

    let numOfItemsToRemove = count
    
    _path.removeLast(numOfItemsToRemove)
    _stack.removeLast(numOfItemsToRemove)
  }
  
  fileprivate func setBoundPath(
    _ newValue: SwiftUI.NavigationPath,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    let dismissedDestination: AnyIdentifiableDestination
    
    switch (newValue.count - _path.count) {
    case 0:
      return
      
    case -1:
      dismissedDestination = _stack.removeLast()
      
    default:
      fatalError(
        "Invalid path update from count `\(_path.count)` to \(newValue.count).",
        sourceFile: sourceFile,
        line: line
      )
    }

    _path = newValue
    
    reportDismiss(of: dismissedDestination)
  }
  
  func appendDelegate<Delegate: StackStateDelegate>(_ delegate: Delegate) {
    delegates[ObjectIdentifier(delegate)] = delegate.eraseToAnyStackStateDelegate()
  }
  
  private func reportDismiss(of destination: AnyIdentifiableDestination) {
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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Binding<SwiftUI.NavigationPath> {
    Binding<SwiftUI.NavigationPath>(
      get: { [unowned wrappedValue] () -> SwiftUI.NavigationPath in
        wrappedValue._path
      },
      set: { [unowned wrappedValue] (updatedPath) in
        wrappedValue.setBoundPath(
          updatedPath,
          sourceFile: sourceFile,
          line: line
        )
      }
    )
  }
}

extension StackState {
  @MainActor
  @inline(__always)
  func stack() -> [AnyIdentifiableDestination] {
    _stack.elements
  }
}

@MainActor
protocol StackStateDelegate: AnyObject {
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination)
}

extension StackStateDelegate {
  @_disfavoredOverload
  func eraseToAnyStackStateDelegate() -> AnyStackStateDelegate {
    AnyStackStateDelegate(self)
  }
  
  func eraseToAnyNavigationQueue() -> AnyStackStateDelegate where Self == AnyStackStateDelegate {
    self
  }
}

@MainActor
final class AnyStackStateDelegate: StackStateDelegate {
  private var _stackStateDidDismiss: ((AnyIdentifiableDestination) -> Void)!
  
  private(set) var isValid = true
  
  init<Delegate: StackStateDelegate>(
    _ delegate: Delegate
  ) {
    assert(Delegate.self != AnyStackStateDelegate.self)
    
    _stackStateDidDismiss = { [weak self, weak delegate] in
      guard let delegate else {
        self?.isValid = false
        return
      }
      
      delegate.stackStateDidDismiss($0)
    }
  }
  
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    _stackStateDidDismiss(destination)
  }
}

#if canImport(XCTest)

extension StackState {
  func testBinding() -> Binding<SwiftUI.NavigationPath> {
    Perception.Bindable(self).path()
  }
}

#endif
