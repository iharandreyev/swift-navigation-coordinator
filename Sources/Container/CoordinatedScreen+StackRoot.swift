//
//  CoordinatedScreen+StackRoot.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI
import SUIOnRemoveFromParent

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
    _NavigationView(
      for: CoordinatorType.DestinationType.self,
      stackState: coordinator.stackNavigator.state,
      rootContent: { [unowned coordinator] in
        coordinator.initialScreen()
      },
      destinationContent: { [weak coordinator] destination in
        coordinator?.screen(for: destination)
      }
    )
  }
}

private struct _NavigationView<
  Destination: ScreenDestinationType,
  RootContent: View,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var stackState: StackState
  
  private let rootContent: () -> RootContent
  private let destinationContent: (Destination) -> DestinationContent
  
  init(
    for destinationType: Destination.Type,
    stackState: StackState,
    rootContent: @escaping () -> RootContent,
    destinationContent: @escaping (Destination) -> DestinationContent
  ) {
    self.stackState = stackState
    self.rootContent = rootContent
    self.destinationContent = destinationContent
  }
  
  var content: some View {
    NavigationStack(
      path: $stackState.path(),
      root: {
        rootContent()
          .navigationDestination(
            for: Destination.self,
            destination: destinationContent
          )
      }
    )
  }
}
