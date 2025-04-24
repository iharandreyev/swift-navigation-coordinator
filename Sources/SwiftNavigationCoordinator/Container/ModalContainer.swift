//
//  ModalContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import CasePaths
import Perception
import SwiftUI
import SwiftUINavigation

public struct ModalContainer<
  Destination: DestinationType,
  Root: View,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var state: ModalState
  
  private let root: () -> Root
  private let destinationContent: (Destination) -> DestinationContent
  
  public init(
    navigator: Navigator,
    root: @escaping () -> Root,
    destinationContent: @escaping (Destination) -> DestinationContent
  ) {
    self.state = navigator._modalState
    self.root = root
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    return root()
      .sheet(
        item: $state.destination().sheet,
        content: destinationContent
      )
      .cover(
        item: $state.destination().cover,
        content: destinationContent
      )
  }
}
