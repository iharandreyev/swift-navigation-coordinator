//
//  StackContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

public struct StackContainer<
  Destination: DestinationType,
  RootContent: View,
  DestinationContent: View
>: ObservingView {
  private let rootContent: () -> RootContent
  private let destinationContent: (Destination) -> DestinationContent
  
  @Perception.Bindable
  private var state: StackState
  
  public init(
    navigator: Navigator,
    rootContent: @escaping () -> RootContent,
    destinationContent: @escaping (Destination) -> DestinationContent
  ) {
    self.state = navigator._stackState
    self.rootContent = rootContent
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    NavigationStack(
      path: $state.path(),
      root: {
        rootContent()
          .navigationDestination(
            for: Destination.self,
            destination: destinationContent
          )
      }
    )
  }
}
