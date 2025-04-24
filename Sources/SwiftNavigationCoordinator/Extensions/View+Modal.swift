//
//  View+Modal.swift
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
  ) -> ModifiedContent<Self, OptionalModalModifier<Coordinator>> {
    modifier(OptionalModalModifier(coordinator: coordinator))
  }
}

public struct OptionalModalModifier<Coordinator: NavigationCoordinatorType>: ViewModifier {
  private let coordinator: Coordinator
  
  @Perception.Bindable
  private var state: ModalState
  
  private let isEnabled: Bool
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    self.state = coordinator.navigator._modalState
    self.isEnabled = Coordinator.ModalDestination.self != DestinationNever.self
  }
  
  public func body(content: Content) -> some View {
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
