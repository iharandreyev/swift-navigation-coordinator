//
//  StackContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
public struct StackContainer<
  DestinationType: ScreenDestinationType,
  RootContent: View,
  DestinationContent: View
>: ObservingView {
  private let rootContent: () -> RootContent
  private let destinationContent: (DestinationType) -> DestinationContent
  
  @Perception.Bindable
  private var state: StackState
  
  public init(
    stackNavigator: StackNavigator<DestinationType>,
    rootContent: @escaping () -> RootContent,
    destinationContent: @escaping (DestinationType) -> DestinationContent
  ) {
    self.state = stackNavigator.state
    self.rootContent = rootContent
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    NavigationStack(
      path: $state.path(),
      root: {
        rootContent()
          .navigationDestination(
            for: DestinationType.self,
            destination: destinationContent
          )
      }
    )
  }
}
