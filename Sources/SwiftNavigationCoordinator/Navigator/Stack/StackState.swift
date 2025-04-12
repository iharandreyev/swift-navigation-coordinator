//
//  StackState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

/// An observable object used to manage stack presentation.
///
/// This object is necessary to keep `NavigationPath` bindings consistent and in sync.
@MainActor
@Perceptible
final class StackState {
  fileprivate var _path: NavigationPath = NavigationPath()

  @PerceptionIgnored
  weak var delegate: StackStateDelegate?
  
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
  func append<Destination: Sendable & Hashable>(
    _ destination: Destination
  ) {
    _path.append(destination)
  }
  /// Removes values from the end of this stack.
  func removeLast(
    _ numOfItemsToRemove: Int = 1
  ) {
    guard numOfItemsToRemove > 0 else { return }
    
    _path.removeLast(numOfItemsToRemove)
  }
  
  func removeAll() {
    guard !isEmpty else { return }
    
    _path.removeLast(count)
  }
  
  fileprivate func setBoundPath(
    _ newValue: NavigationPath,
    file: StaticString,
    line: UInt
  ) {
    let interaction: StackUserInteraction
    switch (newValue.count - _path.count) {
    case 0:
      return
      
    case -1:
      interaction = .pop
      
    case _ where newValue.isEmpty:
      interaction = .popToRoot
      
    default:
      fatalError(
        """
          Invalid path update from count `\(_path.count)` to \(newValue.count). \
          Source: \(file):\(line)
        """,
        file: file,
        line: line
      )
    }

    _path = newValue
    delegate?.userDidChangeStack(with: interaction)
  }
}

extension Perception.Bindable where Value == StackState {
  func path(
    file: StaticString = #file,
    line: UInt = #line
  ) -> Binding<NavigationPath> {
    Binding<NavigationPath>(
      get:  { [unowned wrappedValue] () -> NavigationPath in
        return wrappedValue._path
      },
      set: { [unowned wrappedValue] (updatedPath) in
        wrappedValue.setBoundPath(
          updatedPath,
          file: file,
          line: line
        )
      }
    )
  }
}
