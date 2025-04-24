//
//  ModalCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol ModalCoordinatorType: CoordinatorBase {
  associatedtype ModalDestination: DestinationType
  associatedtype ModalDestinationScreen: View

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> ModalDestinationScreen
}

extension ModalCoordinatorType {
  func screen(forModal destination: ModalDestination) -> some View {
    content(forModal: destination)
  }
}
