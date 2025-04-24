//
//  StackState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

@MainActor
@Perceptible
final class StackState {
  fileprivate var _path: SwiftUI.NavigationPath
  
  @PerceptionIgnored
  fileprivate(set) var stack: [AnyIdentifiableDestination]

  @PerceptionIgnored
  private var delegates: [ObjectIdentifier: AnyStackStateDelegate] = [:]
  
  init(
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    _path = SwiftUI.NavigationPath()
    stack = []
  }
  
  /// A Boolean that indicates whether this stack is empty.
  @PerceptionIgnored
  var isEmpty: Bool {
    _path.isEmpty
  }
  
  /// The number of elements in this stack.
  @PerceptionIgnored
  var count: Int {
    _path.count
  }
  
  /// Appends a new destination value to the end of this stack.
  func append<Destination: Sendable & Hashable & Identifiable>(
    _ destination: Destination
  ) {
    let entry = AnyIdentifiableDestination(destination)
    guard !stack.contains(entry) else {
      fatalError()
    }
    
    logMessage("\(ShortDescription(self)): Append \(ShortDescription(destination))")
    
    _path.append(destination)
    stack.append(entry)
  }
  /// Removes values from the end of this stack.
  func removeLast(
    _ numOfItemsToRemove: Int = 1
  ) {
    guard numOfItemsToRemove > 0 else { return }
    
    logMessage("\(ShortDescription(self)): Remove last \(numOfItemsToRemove)")
    
    _path.removeLast(numOfItemsToRemove)
    stack.removeLast(numOfItemsToRemove)
  }
  
  func firstIndex<Destination: Sendable & Hashable & Identifiable>(
    of destination: Destination
  ) -> Int? {
    stack.firstIndex(of: AnyIdentifiableDestination(destination))
  }
  
  func removeAll() {
    guard !isEmpty else { return }
    
    logMessage("\(ShortDescription(self)): Remove all")
    
    let numOfItemsToRemove = count
    
    _path.removeLast(numOfItemsToRemove)
    stack.removeLast(numOfItemsToRemove)
  }
  
  fileprivate func setBoundPath(
    _ newValue: SwiftUI.NavigationPath,
    sourceFile: StaticString,
    line: UInt
  ) {
    let dismissedDestination: AnyIdentifiableDestination
    
    switch (newValue.count - _path.count) {
    case 0:
      return
      
    case -1:
      dismissedDestination = stack.removeLast()
      
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
