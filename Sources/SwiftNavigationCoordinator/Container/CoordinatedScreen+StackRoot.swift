//
//  CoordinatedScreen+StackRoot.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a stack coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces only with `StackNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build root view` requrest to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations pushed into coordinator's `StackNavigator`;
  public static func stackRoot<
    Coordinator: StackCoordinatorType
  >(
    stackCoordinator coordinator: Coordinator
  ) -> some View {
    _CoordinatedScreen_StackRoot(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_StackRoot<
  Coordinator: StackCoordinatorType
>: View {
  private let coordinator: Coordinator
  
  init(
    coordinator: Coordinator
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    StackContainer(
      navigator: coordinator.navigator,
      rootContent: { [unowned coordinator] in
        coordinator.initialContent()
      },
      destinationContent: { [weak coordinator] destination in
        coordinator?.content(forStack: destination)
      }
    )
  }
}
