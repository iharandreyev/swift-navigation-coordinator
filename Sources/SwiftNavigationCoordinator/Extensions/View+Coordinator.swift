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
  ) -> some View where CoordinatorType.ModalDestination: DestinationType {
    self.modal(
      navigator: coordinator.navigator,
      content: { [unowned coordinator] destination in
        coordinator.content(forModal: destination)
      }
    )
  }
  
  @inline(__always)
  func navigationDestination<CoordinatorType: StackCoordinatorType>(
    for coordinator: CoordinatorType
  ) -> some View where CoordinatorType.StackDestination: DestinationType{
    self.navigationDestination(
      for: CoordinatorType.StackDestination.self,
      destination: { [unowned coordinator] destination in
        coordinator.content(forStack: destination)
      }
    )
  }
}
