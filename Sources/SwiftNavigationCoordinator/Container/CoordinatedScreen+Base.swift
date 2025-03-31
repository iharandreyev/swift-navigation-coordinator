//
//  CoordinatedScreen+Base.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a single screen coordinator.
  ///
  /// The view configures infrastructure to:
  /// * pass `build view` requrests to the coordinator;
  public static func base<
    CoordinatorType: ScreenCoordinatorType
  >(
    coordinator: CoordinatorType
  ) -> some View {
    _CoordinatedScreen_Base(coordinator: coordinator)
  }
}

struct _CoordinatedScreen_Base<
  CoordinatorType: ScreenCoordinatorType
>: View {
  private let coordinator: CoordinatorType

  init(
    coordinator: CoordinatorType
  ) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    coordinator.initialScreen()
  }
}
