//
//  StackCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol StackCoordinatorType: CoordinatorBase {
  associatedtype StackDestination: DestinationType
  associatedtype StackDestinationScreen: View
  
  @ViewBuilder
  func content(forStack destination: StackDestination) -> StackDestinationScreen
}

extension StackCoordinatorType {
  func screen(forStack destination: StackDestination) -> some View {
    content(forStack: destination)
  }
}
