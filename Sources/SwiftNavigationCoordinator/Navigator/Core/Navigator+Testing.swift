//
//  Navigator+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

import OrderedCollections
import Clocks
import SwiftUI

extension Navigator {
  public static func test<
    ModalDestination: DestinationType
  >(
    modalDestination: ModalDestinationPath<ModalDestination>
  ) -> Navigator {
    Navigator(
      initialModalDestination: modalDestination,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test<
    SpecimenDestination: DestinationType
  >(
    specimenDestination: SpecimenDestination
  ) -> Navigator {
    Navigator(
      initialSpecimenDestination: specimenDestination,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }

  public static func test(
    stack: OrderedSet<AnyIdentifiableDestination>
  ) -> Navigator {
    Navigator(
      initialStack: stack,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType
  >(
    modalDestination: ModalDestinationPath<ModalDestination>,
    specimenDestination: SpecimenDestination
  ) -> Navigator {
    Navigator(
      initialModalDestination: modalDestination,
      initialSpecimenDestination: specimenDestination,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test<
    SpecimenDestination: DestinationType
  >(
    specimenDestination: SpecimenDestination,
    stack: OrderedSet<AnyIdentifiableDestination>
  ) -> Navigator {
    Navigator(
      initialSpecimenDestination: specimenDestination,
      initialStack: stack,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test<
    ModalDestination: DestinationType
  >(
    modalDestination: ModalDestinationPath<ModalDestination>,
    stack: OrderedSet<AnyIdentifiableDestination>
  ) -> Navigator {
    Navigator(
      initialModalDestination: modalDestination,
      initialStack: stack,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType
  >(
    modalDestination: ModalDestinationPath<ModalDestination>,
    specimenDestination: SpecimenDestination,
    stack: OrderedSet<AnyIdentifiableDestination>
  ) -> Navigator {
    Navigator(
      initialModalDestination: modalDestination,
      initialSpecimenDestination: specimenDestination,
      initialStack: stack,
      navigationQueue: NavigationQueue(clock: ImmediateClock())
    )
  }
  
  public static func test() -> Navigator {
    Navigator(navigationQueue: NavigationQueue(clock: ImmediateClock()))
  }
  
  func testModalStateBinding<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self
  ) -> Binding<ModalDestinationPath<Destination>?> {
    _modalState.testBinding(for: destinationType)
  }
  
  func testStackStateBinding() -> Binding<SwiftUI.NavigationPath> {
    _stackState.testBinding()
  }
}

#endif
