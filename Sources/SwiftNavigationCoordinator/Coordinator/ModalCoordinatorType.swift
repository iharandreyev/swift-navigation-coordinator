//
//  ModalCoordinatorType.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol ModalCoordinatorType: CoordinatorBase {
  associatedtype DestinationType: ModalDestinationContentType
  associatedtype DestinationScreenType: View
  
  var modalNavigator: any ModalNavigatorType<DestinationType> { get }
  
  @ViewBuilder
  func screen(for destination: DestinationType) -> DestinationScreenType
}
