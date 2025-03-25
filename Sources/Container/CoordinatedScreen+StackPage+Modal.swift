//
//  CoordinatedScreen+StackPage+Modal.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

public extension CoordinatedScreen {
  /// Creates a container view that interfaces with a stack coordinator, that is responsible for managing one of the steps in a flow, that is presented as a stack.
  /// Use this factory method for cases when the managing coordinator interfaces with both `StackNavigator` and `ModalNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build step root view` requrests to the coordinator;
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations pushed into coordinator's `StackNavigator`;
  /// * observe destinations to be presented using coordinator's `ModalNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  static func stackPage<CoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType>(
    modalCoordinator coordinator: CoordinatorType
  ) -> some View {
    CoordinatedScreen_StackPage_Modal(coordinator: coordinator)
  }
}

public struct CoordinatedScreen_StackPage_Modal<CoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType>: View {
  private let coordinator: CoordinatorType

  init(
    coordinator: CoordinatorType
  ) {
    self.coordinator = coordinator
  }
  
  public var body: some View {
    CoordinatedScreen_StackPage(
      coordinator: coordinator
    )
    .modal(
      for: coordinator
    )
  }
}
