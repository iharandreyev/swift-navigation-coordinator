//
//  StackCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol StackCoordinatorType: CoordinatorBase {
  associatedtype DestinationType: ScreenDestinationType
  associatedtype DestinationScreenType: View
  
  var stackNavigator: StackNavigator<DestinationType> { get }
  
  @ViewBuilder
  func screen(for destination: DestinationType) -> DestinationScreenType
}
