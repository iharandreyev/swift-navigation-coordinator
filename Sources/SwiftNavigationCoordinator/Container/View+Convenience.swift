//
//  View+Convenience.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import CasePaths
import Perception
import SwiftUI
import SwiftUINavigation

extension View {
  public func optionalModal<Coordinator: NavigationCoordinatorType>(
    for coordinator: Coordinator
  ) -> some View {
    modifier(OptionalModalModifier(coordinator: coordinator))
  }
  
  public func optionalStackDestination<Coordinator: NavigationCoordinatorType>(
    for coordinator: Coordinator
  ) -> some View {
    modifier(OptionalStackDestinationModifier(coordinator: coordinator))
  }
}

struct OptionalModalModifier<Coordinator: NavigationCoordinatorType>: ViewModifier {
  private let coordinator: Coordinator
  
  @Perception.Bindable
  private var state: ModalState
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    self.state = coordinator.navigator._modalState
  }
  
  func body(content: Content) -> some View {
    body(for: content)
  }
  
  
  @_disfavoredOverload
  func body(for content: Content) -> some View {
    content
  }
  
  func body(for content: Content) -> some View where Coordinator.ModalDestination: DestinationType {
    content.sheet(
      item: $state.destination().sheet,
      content: { [unowned coordinator] in
        coordinator.content(forModal: $0)
      }
    )
    .cover(
      item: $state.destination().cover,
      content: { [unowned coordinator] in
        coordinator.content(forModal: $0)
      }
    )
  }
}

struct OptionalStackDestinationModifier<Coordinator: NavigationCoordinatorType>: ViewModifier {
  private let coordinator: Coordinator
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
  }
  
  func body(content: Content) -> some View {
    body(for: content)
  }
  
  
  @_disfavoredOverload
  func body(for content: Content) -> some View {
    content
  }
  
  func body(for content: Content) -> some View where Coordinator.StackDestination: DestinationType {
    content.navigationDestination(
      for: Coordinator.StackDestination.self,
      destination: { [unowned coordinator] destination in
        coordinator.content(forStack: destination)
      }
    )
  }
}
