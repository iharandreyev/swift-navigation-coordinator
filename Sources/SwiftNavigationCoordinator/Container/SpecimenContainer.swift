//
//  SpecimenContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

public struct SpecimenContainer<
  Destination: DestinationType,
  DestinationContent: View,
  Container: View
>: ObservingView {
  @Perception.Bindable
  private var state: SpecimenState

  private let destinationContent: (Binding<Destination>) -> DestinationContent
  private let transition: (Destination) -> AnyTransition
  
  private let container: (
    _ destination: Binding<Destination>,
    _ destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    _ transition: @escaping (Destination) -> AnyTransition
  ) -> Container
  
  private init(
    navigator: Navigator,
    @ViewBuilder destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition,
    container: @escaping (
      _ destination: Binding<Destination>,
      _ destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
      _ transition: @escaping (Destination) -> AnyTransition
    ) -> Container
  ) {
    self.state = navigator._specimenState
    self.destinationContent = destinationContent
    self.transition = transition
    self.container = container
  }
  
  public init(
    navigator: Navigator,
    @ViewBuilder destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition = { _ in .opacity }
  ) where Container == SpecimenContainerContent<Destination, DestinationContent> {
    self.init(navigator: navigator, destinationContent: destinationContent, transition: transition) {
      SpecimenContainerContent(
        destination: $0,
        destinationContent: $1,
        transition: $2
      )
    }
  }
  
  public init<Coordinator: SpecimenCoordinatorType>(
    coordinator: Coordinator,
    transition: @escaping (Destination) -> AnyTransition = { _ in .opacity }
  ) where
    Destination == Coordinator.SpecimenDestination,
    DestinationContent == Coordinator.SpecimenDestinationContent,
    Container == ModifiedContent<ModifiedContent<SpecimenContainerContent<Destination, DestinationContent>, OptionalModalModifier<Coordinator>>, OptionalStackDestinationModifier<Coordinator>>
  {
    self.init(
      navigator: coordinator.navigator,
      destinationContent: { [unowned coordinator] destination in
        coordinator.content(forSpecimen: destination.wrappedValue)
      },
      transition: transition,
      container: { [unowned coordinator] in
        SpecimenContainerContent(
          destination: $0,
          destinationContent: $1,
          transition: $2
        )
        .optionalModal(for: coordinator)
        .optionalStackDestination(for: coordinator)
      }
    )
  }
  
  public var content: some View {
    SpecimenContainerContent(
      destination: $state.destination(for: Destination.self),
      destinationContent: destinationContent,
      transition: transition
    )
  }
}

public struct SpecimenContainerContent<
  Destination: DestinationType,
  DestinationContent: View
>: View {
  private let destination: Binding<Destination>
  private let destinationContent: (Binding<Destination>) -> DestinationContent
  private let transition: (Destination) -> AnyTransition
  
  init(
    destination: Binding<Destination>,
    destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition
  ) {
    self.destination = destination
    self.destinationContent = destinationContent
    self.transition = transition
  }
  
  public var body: some View {
    Group {
      destinationContent(
        destination
      )
      .id(destination.wrappedValue)
      .tag(destination.wrappedValue)
      .transition(transition(destination.wrappedValue))
    }
    .animation(
      .easeInOut,
      value: destination.wrappedValue
    )
  }
}
