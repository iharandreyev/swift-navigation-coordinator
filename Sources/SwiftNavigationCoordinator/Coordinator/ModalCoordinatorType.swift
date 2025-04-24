//
//  ModalCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol ModalCoordinatorType: CoordinatorBase {
  associatedtype Destination: DestinationType
  associatedtype DestinationScreenType: View

  @ViewBuilder
  func screen(for destination: Destination) -> DestinationScreenType
}
