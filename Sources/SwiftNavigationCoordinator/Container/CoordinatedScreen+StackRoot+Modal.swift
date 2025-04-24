//
//  CoordinatedScreen+StackRoot+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a stack coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces with both `StackNavigator` and `ModalNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build root view` requrest to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations pushed into coordinator's `StackNavigator`;
  /// * observe destinations to be presented using coordinator's `ModalNavigator`;
  public static func stackRoot<
    Coordinator: StackCoordinatorType & ModalCoordinatorType
  >(
    modalCoordinator coordinator: Coordinator
  ) -> some View {
    _CoordinatedScreen_StackRoot_Modal(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_StackRoot_Modal<
  Coordinator: StackCoordinatorType & ModalCoordinatorType
>: View {
  private let coordinator: Coordinator
  
  init(
    coordinator: Coordinator
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    _CoordinatedScreen_StackRoot(
      coordinator: coordinator
    )
    .modal(
      for: coordinator
    )
  }
}
