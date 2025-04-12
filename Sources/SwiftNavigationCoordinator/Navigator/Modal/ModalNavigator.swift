//
//  ModalNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

/// An observable object used to manage optional modal presentation.
@Perceptible
@MainActor
public final class ModalNavigator<
  DestinationType: ModalDestinationContentType
> {
  private let navigationQueue: NavigationQueue
  
  fileprivate(set) public var destination: ModalDestination<DestinationType>?
  
  private init(
    navigationQueue: NavigationQueue
  ) {
    self.navigationQueue = navigationQueue
  }
  
  public convenience init() {
    self.init(navigationQueue: .shared)
  }
  
  public func presentDestination(
    _ destination: ModalDestination<DestinationType>,
    animated: Bool = true
  ) async {
    await setDestination(destination, animated: animated)
  }
  
  public func dismissDestination(
    animated: Bool = true
  ) async {
    await setDestination(nil, animated: animated)
  }
  
  fileprivate func setBoundDestination(
    _ newValue: ModalDestination<DestinationType>?,
    animated: Bool,
    file: StaticString,
    line: UInt
  ) {
    // SwiftUI can only dismiss the destination via binding
    // If some concrete value is passed, then something went horribly wrong
    guard newValue == nil else {
      logWarning(
        """
          Binding is trying to mutate \(ShortDescription(self))
          with non-nil destination, which is prohibited
        """,
        file: file,
        line: line
      )
      return
    }
    
    Task { [weak self] in
      guard let self else { return }
      
      await setDestination(newValue, animated: animated)
    }
  }
  
  #warning("TODO: Investigate whether replacing destination does not break animation completion")
  private func setDestination(
    _ destination: ModalDestination<DestinationType>?,
    animated: Bool
  ) async {
    guard self.destination != destination else { return }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        self.destination = destination
      },
      animated: animated
    )
  }
}

#if canImport(XCTest)

extension ModalNavigator {
  static func test(
    destination: ModalDestination<DestinationType>? = nil,
    navigationQueue: NavigationQueue = .test()
  ) -> ModalNavigator {
    let navigator = ModalNavigator(navigationQueue: navigationQueue)
    navigator.destination = destination
    return navigator
  }
}

#endif

extension Perception.Bindable {
  @MainActor
  public func destination<
    Destination: ModalDestinationContentType
  >(
    animated: Bool = true,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Binding<ModalDestination<Destination>?> where Value == ModalNavigator<Destination> {
    Binding<ModalDestination<Destination>?>(
      get: { [unowned wrappedValue] () -> ModalDestination<Destination>? in
        wrappedValue.destination
      },
      set: { [unowned wrappedValue] (expectedNil) in
        wrappedValue.setBoundDestination(
          expectedNil,
          animated: animated,
          file: file,
          line: line
        )
      }
    )
  }
}
