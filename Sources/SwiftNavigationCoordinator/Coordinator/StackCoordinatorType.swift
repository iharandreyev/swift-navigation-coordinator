//
//  StackCoordinatorType.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol StackCoordinatorType: CoordinatorBase {
  associatedtype DestinationType: ScreenDestinationType
  associatedtype DestinationScreenType: View
  
  var stackNavigator: any StackNavigatorType<DestinationType> { get }
  
  @ViewBuilder
  func screen(for destination: DestinationType) -> DestinationScreenType
}
