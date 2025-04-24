//
//  StackContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import SwiftUI

public struct StackContainer<
  Coordinator: StackCoordinatorType,
  InitialContent: View
>: ObservingView {
  private let coordinator: Coordinator
  private let initialContent: () -> InitialContent
  
  @Perception.Bindable
  private var state: StackState
  
  private init(
    coordinator: Coordinator,
    initialContent: @escaping () -> InitialContent
  ) {
    self.coordinator = coordinator
    self.initialContent = initialContent
    self.state = coordinator.navigator._stackState
  }
  
  public var content: some View {
    NavigationStack(
      path: $state.path(),
      root: {
        initialContent()
          .navigationDestination(
            for: Coordinator.StackDestination.self,
            destination: { [weak coordinator] destination in
              coordinator?.content(forStack: destination)
            }
          )
      }
    )
    .optionalModal(for: coordinator)
  }
}
