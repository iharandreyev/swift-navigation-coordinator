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
    animation: Animation? = .default
  ) async {
    await setDestination(
      destination,
      animation: animation
    )
  }
  
  public func dismissDestination(
    animation: Animation? = .default
  ) async {
    await setDestination(
      nil,
      animation: animation
    )
  }
  
  fileprivate func setBoundDestination(
    _ newValue: ModalDestination<DestinationType>?,
    animation: Animation?,
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
      
      await setDestination(
        nil,
        animation: animation
      )
    }
  }
  
  #warning("TODO: Investigate whether replacing destination does not break animation completion")
  private func setDestination(
    _ destination: ModalDestination<DestinationType>?,
    animation: Animation?
  ) async {
    guard self.destination != destination else { return }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        self.destination = destination
      },
      animation: animation
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
    updateAnimation: Animation? = .default,
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
          animation: updateAnimation,
          file: file,
          line: line
        )
      }
    )
  }
}
