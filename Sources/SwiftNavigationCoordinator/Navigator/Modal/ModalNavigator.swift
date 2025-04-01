//
//  ModalNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Implement async methods to wait for animation complete")
/// An observable object used to manage optional modal presentation.
@Perceptible
@MainActor
public final class ModalNavigator<
  DestinationType: ModalDestinationContentType
> {
  fileprivate(set) public var destination: ModalDestination<DestinationType>?
  
  public init() { }
  
  public func presentDestination(
    _ destination: ModalDestination<DestinationType>
  ) async {
    await setDestination(destination)
  }
  
  public func dismissDestination() async {
    await setDestination(nil)
  }
  
  fileprivate func setBoundDestination(
    _ newValue: ModalDestination<DestinationType>?,
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
    
    Task.detached { [unowned self] in
      await setDestination(nil)
    }
  }
  
  private func setDestination(_ destination: ModalDestination<DestinationType>?) async {
    await NavigationQueue.shared.scheduleUiUpdate { [weak self] in
      guard let self else { return }
      self.destination = destination
      
    }
  }
}

extension Perception.Bindable {
  @MainActor
  public func destination<
    Destination: ModalDestinationContentType
  >(
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
          file: file,
          line: line
        )
      }
    )
  }
}
