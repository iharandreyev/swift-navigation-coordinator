//
//  View+Coordinator.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension View {
  @inline(__always)
  func navigationDestination<CoordinatorType: StackCoordinatorType>(
    for coordinator: CoordinatorType
  ) -> some View {
    self.navigationDestination(
      for: CoordinatorType.DestinationType.self,
      destination: { [unowned coordinator] destination in
        coordinator.screen(for: destination)
      }
    )
  }
}
