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

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
public struct ModalContainer<
  DestinationType: ModalDestinationContentType,
  Root: View,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var modalNavigator: ModalNavigator<DestinationType>
  
  private let root: () -> Root
  private let destinationContent: (DestinationType) -> DestinationContent
  
  public init(
    modalNavigator: ModalNavigator<DestinationType>,
    root: @escaping () -> Root,
    destinationContent: @escaping (DestinationType) -> DestinationContent
  ) {
    self.modalNavigator = modalNavigator
    self.root = root
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    return root()
      .sheet(
        item: $modalNavigator.destination().sheet,
        content: destinationContent
      )
      .cover(
        item: $modalNavigator.destination().cover,
        content: destinationContent
      )
  }
}
