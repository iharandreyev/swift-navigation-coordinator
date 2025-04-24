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
  
  private let isEnabled: Bool
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    self.state = coordinator.navigator._modalState
    self.isEnabled = Coordinator.ModalDestination.self != DestinationNever.self
  }
  
  func body(content: Content) -> some View {
    if isEnabled {
      activeBody(content: content)
    } else {
      inactive(content: content)
    }
  }
  
  private func activeBody(content: Content) -> some View {
    WithPerceptionTracking {
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
  
  private func inactive(content: Content) -> some View {
    content
  }
}

struct OptionalStackDestinationModifier<Coordinator: NavigationCoordinatorType>: ViewModifier {
  private let coordinator: Coordinator
  private let isEnabled: Bool
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    self.isEnabled = Coordinator.StackDestination.self != DestinationNever.self
  }
  
  func body(content: Content) -> some View {
    if isEnabled {
      activeBody(content: content)
    } else {
      inactive(content: content)
    }
  }
  
  private func activeBody(content: Content) -> some View {
    content.navigationDestination(
      for: Coordinator.StackDestination.self,
      destination: { [unowned coordinator] destination in
        coordinator.content(forStack: destination)
      }
    )
  }
  
  private func inactive(content: Content) -> some View {
    content
  }
}
