//
//  CoordinatedScreen+StackPage.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a stack coordinator, that is responsible for managing one of the steps in a flow, that is presented as a stack.
  /// Use this factory method for cases when the managing coordinator interfaces only with `StackNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build step root view` requrests to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations pushed into coordinator's `StackNavigator`;
  public static func stackPage<
    Coordinator: StackCoordinatorType
  >(
    stackCoordinator coordinator: Coordinator
  ) -> some View {
    _CoordinatedScreen_StackPage(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_StackPage<
  Coordinator: StackCoordinatorType
>: View {
  private let coordinator: Coordinator

  init(
    coordinator: Coordinator
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    _CoordinatedScreen_Base(
      coordinator: coordinator
    )
    .navigationDestination(
      for: coordinator
    )
  }
}
