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
      navigationQueue: .shared
    )
  }
  
  private init(
    initialDestination: DestinationType,
    navigationQueue: NavigationQueue
  ) {
    self.destination = initialDestination
    self.navigationQueue = navigationQueue
  }
  
  public func replaceDestination(with destination: DestinationType) async {
    await setDestination(destination)
  }
  
  fileprivate func setBoundDestination(_ newValue: DestinationType) {
    Task { [weak self] in
      guard let self else { return }
      
      await setDestination(newValue)
    }
  }
  
  private func setDestination(_ destination: DestinationType) async {
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
    navigationQueue: NavigationQueue = .test()
  ) -> SpecimenNavigator {
    SpecimenNavigator(initialDestination: destination, navigationQueue: navigationQueue)
  }
}

#endif

extension Perception.Bindable {
  @MainActor
  public func destination<
    Destination: ScreenDestinationType
  >() -> Binding<Destination> where Value == SpecimenNavigator<Destination> {
    Binding<Destination>(
      get:  { [unowned wrappedValue] () -> Destination in
        wrappedValue.destination
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue)
      }
    )
  }
}
