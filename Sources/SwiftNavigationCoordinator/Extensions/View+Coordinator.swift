//
//  View+Coordinator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension View {
  @inline(__always)
  func modal<CoordinatorType: ModalCoordinatorType>(
    for coordinator: CoordinatorType
  ) -> some View {
    self.modal(
      ofType: CoordinatorType.DestinationType.self,
      from: coordinator.modalNavigator.state,
      content: { [unowned coordinator] destination in
        coordinator.screen(for: destination)
      }
    )
  }
  
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
