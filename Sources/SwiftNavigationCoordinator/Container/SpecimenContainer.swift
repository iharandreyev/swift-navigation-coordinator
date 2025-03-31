//
//  SpecimenContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
public struct SpecimenContainer<
  DestinationType: ScreenDestinationType,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var specimenNavigator: SpecimenNavigator<DestinationType>
  
  private let destinationContent: (Binding<DestinationType>) -> DestinationContent
  
  public init(
    specimenNavigator: SpecimenNavigator<DestinationType>,
    @ViewBuilder destinationContent: @escaping (Binding<DestinationType>) -> DestinationContent
  ) {
    self.specimenNavigator = specimenNavigator
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    destinationContent(
      $specimenNavigator.destination()
    )
    .animation(
      .easeInOut,
      value: specimenNavigator.destination
    )
  }
}
