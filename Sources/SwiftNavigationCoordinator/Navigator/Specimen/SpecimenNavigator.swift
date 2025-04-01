//
//  SpecimenNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

#warning("TODO: Add async implementations to process animations properly")
/// An observable object used to manage presentation of one of many destinations.
@MainActor
@Perceptible
public final class SpecimenNavigator<
  DestinationType: ScreenDestinationType
> {
  fileprivate(set) public var destination: DestinationType

  public init(
    initialDestination: DestinationType
  ) {
    self.destination = initialDestination
  }

  public func replaceDestination(with destination: DestinationType) async {
    await setDestination(destination)
  }
  
  fileprivate func setBoundDestination(_ newValue: DestinationType) {
    Task.detached { [unowned self] in
      await setDestination(newValue)
    }
  }
  
  private func setDestination(_ destination: DestinationType) async {
    await NavigationQueue.shared.scheduleUiUpdate { [weak self] in
      guard let self else { return }
      self.destination = destination
    }
  }
}

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
