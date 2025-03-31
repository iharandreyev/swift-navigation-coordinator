//
//  ModalNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
#warning("TODO: Implement async methods to wait for animation complete")
/// An observable object used to manage optional modal presentation.
@available(iOS 16, *)
@Perceptible
@MainActor
public final class ModalNavigator<
  DestinationType: ModalDestinationContentType
> {
  fileprivate(set) public var destination: ModalDestination<DestinationType>?

  public init() { }

  public func presentDestination(
    _ destination: ModalDestination<DestinationType>
  ) {
    self.destination = destination
  }
  
  public func dismissDestination() {
    self.destination = nil
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
    
    self.destination = nil
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
