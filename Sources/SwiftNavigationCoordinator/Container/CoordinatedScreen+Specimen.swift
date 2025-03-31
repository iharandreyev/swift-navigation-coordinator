//
//  CoordinatedScreen+Specimen.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI
import SUIOnRemoveFromParent

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
public extension CoordinatedScreen {
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  static func specimen<CoordinatorType: SpecimenCoordinatorType, Content: View>(
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
  static func specimen<CoordinatorType: SpecimenCoordinatorType>(
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

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
struct _CoordinatedScreen_Specimen<
  CoordinatorType: SpecimenCoordinatorType,
  Content: View
>: View {
  private let coordinator: CoordinatorType
  private let specimenNavigator: SpecimenNavigator<CoordinatorType.DestinationType>
  
  private let contentBuilder: (Binding<CoordinatorType.DestinationType>) -> Content
  
  init(
    coordinator: CoordinatorType,
    @ViewBuilder content: @escaping (Binding<CoordinatorType.DestinationType>) -> Content
  ) {
    self.coordinator = coordinator
    self.specimenNavigator = coordinator.specimenNavigator
    self.contentBuilder = content
  }
  
  var body: some View {
    SpecimenContainer(
      specimenNavigator: coordinator.specimenNavigator,
      destinationContent: contentBuilder
    )
    .onRemoveFromParent(
      perform: { [weak coordinator] in
        coordinator?.finish()
      }
    )
  }
}
