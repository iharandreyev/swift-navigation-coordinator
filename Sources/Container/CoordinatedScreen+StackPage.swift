//
//  CoordinatedScreen+StackPage.swift
//  SUINavigationCoordinator
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
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  public static func stackPage<
    CoordinatorType: ScreenCoordinatorType & StackCoordinatorType
  >(
    stackCoordinator coordinator: CoordinatorType
  ) -> some View {
    _CoordinatedScreen_StackPage(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_StackPage<
  CoordinatorType: ScreenCoordinatorType & StackCoordinatorType
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
    .navigationDestination(
      for: coordinator
    )
  }
}
