//
//  ModalCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol ModalCoordinatorType: CoordinatorBase {
  associatedtype DestinationType: ModalDestinationContentType
  associatedtype DestinationScreenType: View
  
  var modalNavigator: ModalNavigator<DestinationType> { get }
  
  @ViewBuilder
  func screen(for destination: DestinationType) -> DestinationScreenType
}
