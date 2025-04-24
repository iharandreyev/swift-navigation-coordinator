//
//  SpecimenContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

#warning("TODO: Documentation")
public enum SpecimenContainer {
  @MainActor
  public static func `for`<
    Destination: DestinationType,
    DestinationContent: View
  >(
    navigator: Navigator,
    @ViewBuilder destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition = { _ in .opacity }
  ) -> some View {
    SpecimenContentContainer(
      state: navigator._specimenState,
      destinationContent: destinationContent,
      transition: transition
    )
  }
  
  @MainActor
  public static func `for`<
    Coordinator: SpecimenCoordinatorType
  >(
    coordinator: Coordinator,
    transition: @escaping (Coordinator.SpecimenDestination) -> AnyTransition = { _ in .opacity }
  ) -> some View {
    SpecimenContentContainer(
      state: coordinator.navigator._specimenState,
      destinationContent: { [unowned coordinator] destination in
        coordinator.content(forSpecimen: destination.wrappedValue)
      },
      transition: transition
    )
    .optionalModal(for: coordinator)
    .optionalStackDestination(for: coordinator)
  }
}

private struct SpecimenContentContainer<
  Destination: DestinationType,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var state: SpecimenState
  
  private let destinationContent: (Binding<Destination>) -> DestinationContent
  private let transition: (Destination) -> AnyTransition
  
  init(
    state: SpecimenState,
    destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition
  ) {
    self.state = state
    self.destinationContent = destinationContent
    self.transition = transition
  }
  
  var content: some View {
    SpecimenContent(
      destination: $state.destination(for: Destination.self),
      destinationContent: destinationContent,
      transition: transition
    )
  }
}

private struct SpecimenContent<
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
  
  var body: some View {
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
