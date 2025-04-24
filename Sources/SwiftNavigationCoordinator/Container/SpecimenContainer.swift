//
//  SpecimenContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import Perception
import SwiftUI

public struct SpecimenContainer<
  Destination: DestinationType,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var state: SpecimenState
  
  private let destinationContent: (Binding<Destination>) -> DestinationContent
  
  public init(
    navigator: Navigator,
    @ViewBuilder destinationContent: @escaping (Binding<Destination>) -> DestinationContent
  ) {
    self.state = navigator._specimenState
    self.destinationContent = destinationContent
  }
  
  public var content: some View {
    destinationContent(
      $state.destination(for: Destination.self)
    )
    .animation(
      .easeInOut,
      value: state.destination(for: Destination.self)
    )
  }
}
