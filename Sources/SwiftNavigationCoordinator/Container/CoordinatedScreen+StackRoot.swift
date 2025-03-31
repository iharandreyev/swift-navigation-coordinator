//
//  CoordinatedScreen+StackRoot.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a stack coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces only with `StackNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build root view` requrest to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations pushed into coordinator's `StackNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  public static func stackRoot<
    CoordinatorType: ScreenCoordinatorType & StackCoordinatorType
  >(
    stackCoordinator coordinator: CoordinatorType
  ) -> some View {
    _CoordinatedScreen_StackRoot(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_StackRoot<
  CoordinatorType: ScreenCoordinatorType & StackCoordinatorType
>: View {
  private let coordinator: CoordinatorType
  
  init(
    coordinator: CoordinatorType
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    StackContainer(
      stackNavigator: coordinator.stackNavigator,
      rootContent: { [unowned coordinator] in
        coordinator.initialScreen()
      },
      destinationContent: { [weak coordinator] destination in
        coordinator?.screen(for: destination)
      }
    )
    .onRemoveFromHierarchy(finish: coordinator)
  }
}
