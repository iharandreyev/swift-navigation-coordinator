//
//  ModalNavigator.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

@MainActor
public protocol ModalNavigatorType<DestinationType> {
  associatedtype DestinationType: ModalDestinationContentType
  
  var state: ModalState { get }
  
  var currentDestination: ModalDestination<AnyIdentifiableDestination>? { get }
  
  func presentDestination(
    _ destination: ModalDestination<DestinationType>
  )
  
  func dismissDestination()
}

@MainActor
public struct ModalNavigator<
  DestinationType: ModalDestinationContentType
>: ModalNavigatorType {
  public let state: ModalState

  public init(
    state: ModalState = ModalState()
  ) {
    self.state = state
  }
  
  public var currentDestination: ModalDestination<AnyIdentifiableDestination>? {
    state._destination
  }

  public func presentDestination(
    _ destination: ModalDestination<DestinationType>
  ) {
    state.presentDestination(destination)
  }
  
  public func dismissDestination() {
    state.dismissDestination()
  }
}
