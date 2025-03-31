//
//  CoordinatedScreen+Base+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a single screen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces only with `ModalNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build view` requrests to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `ModalNavigator`;
  public static func base<
    CoordinatorType: ScreenCoordinatorType & ModalCoordinatorType
  >(
    modalCoordinator coordinator: CoordinatorType
  ) -> some View {
    _CoordinatedScreen_Base_Modal(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_Base_Modal<
  CoordinatorType: ScreenCoordinatorType & ModalCoordinatorType
>: View {
  private let coordinator: CoordinatorType

  init(
    coordinator: CoordinatorType
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    _CoordinatedScreen_Base(
      coordinator: coordinator
    )
    .modal(
      for: coordinator
    )
  }
}
