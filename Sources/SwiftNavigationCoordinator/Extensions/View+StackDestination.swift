//
//  View+StackDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

extension View {
  public func optionalStackDestination<Coordinator: NavigationCoordinatorType>(
    for coordinator: Coordinator
  ) -> ModifiedContent<Self, OptionalStackDestinationModifier<Coordinator>> {
    modifier(OptionalStackDestinationModifier(coordinator: coordinator))
  }
}

public struct OptionalStackDestinationModifier<Coordinator: NavigationCoordinatorType>: ViewModifier {
  private let coordinator: Coordinator
  private let isEnabled: Bool
  
  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    self.isEnabled = Coordinator.StackDestination.self != DestinationNever.self
  }
  
  public func body(content: Content) -> some View {
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
