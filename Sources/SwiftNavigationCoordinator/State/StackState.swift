//
//  StackState.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
/// An observable object used to manage stack presentation.
@available(iOS 16, *)
@MainActor
@Perceptible
final public class StackState {
  fileprivate var _path: NavigationPath = NavigationPath() {
    didSet {
      if _path.isEmpty {
        // SwiftUI popped to root
        stack.removeAll()
        return
      }
      
      switch (_path.count - stack.count) {
      case -1:
        // SwiftUI popped a view
        stack.removeLast()
      case 0:
        // StackState updated _path
        return
      default:
        fatalError("StackState is out of sync")
      }
    }
  }
  
  @PerceptionIgnored
  fileprivate(set) public var stack: [AnyDestination] = []
  
  public init() { }
  
  /// A Boolean that indicates whether this stack is empty.
  @PerceptionIgnored
  public var isEmpty: Bool {
    _path.isEmpty
  }
  
  /// The number of elements in this stack.
  @PerceptionIgnored
  public var count: Int {
    _path.count
  }
  
  /// Appends a new destination value to the end of this stack.
  public func append<Destination: Sendable & Hashable>(
    _ destination: Destination
  ) {
    stack.append(AnyDestination(destination))
    _path.append(destination)
  }
  /// Removes values from the end of this stack.
  public func removeLast(
    _ numOfItemsToRemove: Int = 1
  ) {
    guard numOfItemsToRemove > 0 else { return }
    
    stack.removeLast(numOfItemsToRemove)
    _path.removeLast(numOfItemsToRemove)
  }
}

extension Perception.Bindable where Value == StackState {
  public func path() -> Binding<NavigationPath> {
    Binding<NavigationPath>(
      get:  { [unowned wrappedValue] () -> NavigationPath in
        return wrappedValue._path
      },
      set: { [unowned wrappedValue] (updatedPath) in
        wrappedValue._path = updatedPath
      }
    )
  }
}
