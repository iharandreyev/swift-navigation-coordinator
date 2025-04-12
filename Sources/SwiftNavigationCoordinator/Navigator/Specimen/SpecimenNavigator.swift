//
//  SpecimenNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

/// An observable object used to manage presentation of one of many destinations.
@MainActor
@Perceptible
public final class SpecimenNavigator<
  DestinationType: ScreenDestinationType
> {
  private let navigationQueue: NavigationQueue
  
  fileprivate(set) public var destination: DestinationType
  
  public convenience init(
    initialDestination: DestinationType
  ) {
    self.init(
      initialDestination: initialDestination,
      navigationQueue: Environment.navigationQueue
    )
  }
  
  private init(
    initialDestination: DestinationType,
    navigationQueue: NavigationQueue
  ) {
    self.destination = initialDestination
    self.navigationQueue = navigationQueue
  }
  
  public func replaceDestination(
    with destination: DestinationType,
    animated: Bool = true
  ) async {
    await setDestination(destination, animated: animated)
  }
  
  fileprivate func setBoundDestination(
    _ newValue: DestinationType,
    animated: Bool
  ) {
    Task { [weak self] in
      guard let self else { return }
      
      await setDestination(newValue, animated: animated)
    }
  }
  
  private func setDestination(
    _ destination: DestinationType,
    animated: Bool
  ) async {
    guard self.destination != destination else { return }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        self.destination = destination
      },
      animated: true
    )
  }
}

#if canImport(XCTest)

import Clocks

extension SpecimenNavigator {
  static func test(
    destination: DestinationType,
    navigationQueue: NavigationQueue = Environment.navigationQueue
  ) -> SpecimenNavigator {
    Environment.assert(.test)
    
    return SpecimenNavigator(
      initialDestination: destination,
      navigationQueue: navigationQueue
    )
  }
}

#endif

extension Perception.Bindable {
  @MainActor
  public func destination<
    Destination: ScreenDestinationType
  >(
    animated: Bool = true
  ) -> Binding<Destination> where Value == SpecimenNavigator<Destination> {
    Binding<Destination>(
      get:  { [unowned wrappedValue] () -> Destination in
        wrappedValue.destination
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue, animated: animated)
      }
    )
  }
}
