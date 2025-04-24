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
  
  public static func root(
    coordinator: Coordinator,
    initialContent: @escaping () -> InitialContent
  ) -> Self {
    StackContainer(
      coordinator: coordinator,
      initialContent: initialContent
    )
  }
  
  public static func leaf(
    coordinator: Coordinator
  ) -> Self where InitialContent == Coordinator.InitialContent {
    StackContainer(
      coordinator: coordinator,
      initialContent: { [unowned coordinator] in
        coordinator.initialContent()
      }
    )
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
