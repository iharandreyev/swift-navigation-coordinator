//
//  View+Coordinator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI
import SUIOnRemoveFromParent

extension View {
  @inline(__always)
  public func modal<CoordinatorType: ModalCoordinatorType>(
    for coordinator: CoordinatorType
  ) -> some View {
    self.modal(
      modalNavigator: coordinator.modalNavigator,
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
  
  @inline(__always)
  public func onRemoveFromHierarchy(
    finish coordinator: CoordinatorBase
  ) -> some View {
    self.onRemoveFromParent(
      perform: { [weak coordinator] in
        guard let coordinator else { return }
        guard !coordinator.isFinished else { return }

        Task {
          await coordinator.finish()
        }
      }
    )
  }
}
