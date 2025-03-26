//
//  CoordinatedScreen+Specimen.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SUIOnRemoveFromParent
import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  public static func specimen<
    CoordinatorType: SpecimenCoordinatorType,
    Content: View
  >(
    coordinator: CoordinatorType,
    @ViewBuilder content: @escaping (Binding<CoordinatorType.DestinationType>) -> Content
  ) -> some View {
    _CoordinatedScreen_Specimen(
      coordinator: coordinator,
      content: content
    )
  }
  
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  public static func specimen<
    CoordinatorType: SpecimenCoordinatorType
  >(
    coordinator: CoordinatorType
  ) -> some View {
    _CoordinatedScreen_Specimen(
      coordinator: coordinator,
      content: { [unowned coordinator] destination in
        coordinator.screen(
          for: destination.wrappedValue
        )
      }
    )
  }
}

struct _CoordinatedScreen_Specimen<
  CoordinatorType: SpecimenCoordinatorType,
  Content: View
>: ObservingView {
  private let coordinator: CoordinatorType
  @Perception.Bindable
  private var state: SpecimenState
  
  private let contentBuilder: (Binding<CoordinatorType.DestinationType>) -> Content
  
  init(
    coordinator: CoordinatorType,
    @ViewBuilder content: @escaping (Binding<CoordinatorType.DestinationType>) -> Content
  ) {
    self.coordinator = coordinator
    self.state = coordinator.specimenNavigator.state
    self.contentBuilder = content
  }
  
  var content: some View {
    contentBuilder(
      $state.destinationOf(CoordinatorType.DestinationType.self)
    )
    .onRemoveFromParent(
      perform: { [weak coordinator] in
        coordinator?.finish()
      }
    )
    .animation(
      .easeInOut,
      value: state._destination
    )
  }
}
