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
  
  public func replaceDestination(
    with destination: DestinationType,
    animation: Animation? = .default
  ) async {
    await setDestination(
      destination,
      animation: animation
    )
  }
  
  fileprivate func setBoundDestination(
    _ newValue: DestinationType,
    animation: Animation?
  ) {
    Task { [weak self] in
      guard let self else { return }
      
      await setDestination(
        newValue,
        animation: animation
      )
    }
  }
  
  private func setDestination(
    _ destination: DestinationType,
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
  >(
    updateAnimation: Animation? = .default
  ) -> Binding<Destination> where Value == SpecimenNavigator<Destination> {
    Binding<Destination>(
      get:  { [unowned wrappedValue] () -> Destination in
        wrappedValue.destination
      },
      set: { [unowned wrappedValue] (newValue) in
        wrappedValue.setBoundDestination(newValue, animation: updateAnimation)
      }
    )
  }
}
