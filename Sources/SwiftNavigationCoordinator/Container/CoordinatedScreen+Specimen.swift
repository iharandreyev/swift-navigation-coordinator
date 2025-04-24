//
//  CoordinatedScreen+Specimen.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build destination view` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  public static func specimen<
    Coordinator: SpecimenCoordinatorType
  >(
    coordinator: Coordinator
  ) -> some View {
    SpecimenContainer(
      navigator: coordinator.navigator,
      destinationContent: { [unowned coordinator] destination in
        coordinator.content(
          forSpecimen: destination.wrappedValue
        )
      }
    )
  }
}
