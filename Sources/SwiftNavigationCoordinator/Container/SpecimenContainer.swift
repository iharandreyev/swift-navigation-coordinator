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
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var state: SpecimenState
  
  private let destinationContent: (Binding<Destination>) -> DestinationContent
  private let transition: (Destination) -> AnyTransition
  
  public init(
    navigator: Navigator,
    @ViewBuilder destinationContent: @escaping (Binding<Destination>) -> DestinationContent,
    transition: @escaping (Destination) -> AnyTransition = { _ in .opacity }
  ) {
    self.state = navigator._specimenState
    self.destinationContent = destinationContent
    self.transition = transition
  }
  
  public init<Coordinator: SpecimenCoordinatorType>(
    coordinator: Coordinator,
    transition: @escaping (Destination) -> AnyTransition = { _ in .opacity }
  ) where Destination == Coordinator.SpecimenDestination, DestinationContent == Coordinator.SpecimenDestinationContent {
    self.init(
      navigator: coordinator.navigator,
      destinationContent: { [unowned coordinator] destination in
        coordinator.content(forSpecimen: destination.wrappedValue)
      },
      transition: transition
    )
  }
  
  public var content: some View {
    let currentDestination = currentDestination()
    
    return Group {
      destinationContent(
        $state.destination(for: Destination.self)
      )
      .id(currentDestination)
      .tag(currentDestination)
    }
    .animation(
      .easeInOut,
      value: currentDestination
    )
  }
  
  private func currentDestination() -> Destination {
    state.destination(for: Destination.self)
  }
}
