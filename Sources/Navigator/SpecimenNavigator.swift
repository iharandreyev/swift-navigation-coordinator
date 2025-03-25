//
//  SpecimenNavigator.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

@MainActor
public protocol SpecimenNavigatorType<DestinationType> {
  associatedtype DestinationType: ScreenDestinationType
  
  var state: SpecimenState { get }

  var currentDestination: AnyDestination { get }
  
  func replaceDestination(with destination: DestinationType)
}

@MainActor
public struct SpecimenNavigator<
  DestinationType: ScreenDestinationType
>: SpecimenNavigatorType {
  public let state: SpecimenState

  public init(
    state: SpecimenState
  ) {
    self.state = state
  }
  
  public init(
    initialDestination: DestinationType
  ) {
    self.state = SpecimenState(initial: initialDestination)
  }
  
  public var currentDestination: AnyDestination {
    state._destination
  }

  public func replaceDestination(with destination: DestinationType) {
    state.replaceDestination(with: destination)
  }
}
