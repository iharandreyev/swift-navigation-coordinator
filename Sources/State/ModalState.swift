//
//  ModalState.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
/// An observable object used to manage optional modal presentation.
@available(iOS 16, *)
@MainActor
@Perceptible
final public class ModalState {
  internal fileprivate(set) var _destination: ModalDestination<AnyIdentifiableDestination>?
  
  @PerceptionIgnored
  public var isEmpty: Bool {
    _destination == nil
  }
  
  public init() {}
  
  public func presentDestination<
    Destination: Sendable & Hashable
  >(
    _ destination: ModalDestination<Destination>
  ) {
    logWarning(
      """
        Another destination \(ShortDescription(_destination))
        is already presented modally. \
        It will be replaced, however this may not be the behavior you want.
      """
    )
    switch destination {
    case let .cover(destination):
      _destination = .cover(AnyIdentifiableDestination(destination))
    case let .sheet(destination):
      _destination = .sheet(AnyIdentifiableDestination(destination))
    }
  }
  
  public func dismissDestination() {
    self._destination = nil
  }
}

extension Perception.Bindable where Value == ModalState {
  @MainActor
  public func destinationOf<Destination: ModalDestinationContentType>(
    _ destinationType: Destination.Type
  ) -> Binding<ModalDestination<Destination>?> {
    Binding<ModalDestination<Destination>?>(
      get:  { [unowned wrappedValue] () -> ModalDestination<Destination>? in
        switch wrappedValue._destination {
        case let .cover(destination):
          guard let destination: Destination = destination.extract() else {
            logWarning("Modal cover destination contains unexpected type. Returning nil to avoid hard crash")
            return .none
          }
          return .cover(destination)
          
        case let .sheet(destination):
          guard let destination: Destination = destination.extract() else {
            logWarning("Modal sheet destination contains unexpected type. Returning nil to avoid hard crash")
            return .none
          }
          return .sheet(destination)
          
        case .none:
          return .none
        }
      },
      set: { [unowned wrappedValue] (expectedNil) in
        // SwiftUI can only dismiss the destination via binding
        // If some concrete value is passed, then something went horribly wrong
        guard expectedNil == nil else {
          logWarning("Binding is trying to mutate ModalState, which is prohibited. Ignoring request")
          return
        }
        
        wrappedValue._destination = nil
      }
    )
  }
}
