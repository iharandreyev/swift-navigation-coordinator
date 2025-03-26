//
//  SpecimenState.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
/// An observable object used to manage presentation of one of many destinations.
@available(iOS 16, *)
@MainActor
@Perceptible
public class SpecimenState {
  internal fileprivate(set) var _destination: AnyDestination
  
  public init<Destination: ScreenDestinationType>(initial: Destination) {
    _destination = AnyDestination(initial)
  }
  
  public func replaceDestination<
    Destination: Sendable & Hashable
  >(
    with destination: Destination
  ) {
    _destination = AnyDestination(destination)
  }
}

extension Perception.Bindable where Value == SpecimenState {
  @MainActor
  public func destinationOf<Destination: ScreenDestinationType>(
    _ destinationType: Destination.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Binding<Destination> {
    Binding<Destination>(
      get:  { [unowned wrappedValue] () -> Destination in
        let _destination = wrappedValue._destination
        
        guard let destination = _destination.extract(type: Destination.self) else {
          fatalError(
            """
              The state contains invalid specimen destination.                        \
              Expected type is `\(ShortDescription(Destination.self))`.               \
              Wrapped type is `\(ShortDescription(type(of: _destination.wrapped)))`.
            """,
            file: file,
            line: line
          )
        }
        
        return destination
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue._destination = AnyDestination(newValue)
      }
    )
  }
}
