//
//  SpecimenCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol SpecimenCoordinatorType: CoordinatorBase {
  associatedtype Destination: DestinationType
  associatedtype DestinationScreenType: View

  @ViewBuilder
  func screenContent(for destination: Destination) -> DestinationScreenType
  func screenTransition(for destination: Destination) -> AnyTransition
}

extension SpecimenCoordinatorType {
  public func screen(
    for destination: Destination
  ) -> some View {
    screenContent(
      for: destination
    )
    .transition(
      screenTransition(for: destination)
    )
    .id(destination)
  }
  
  public func screenTransition(for destination: Destination) -> AnyTransition {
    .opacity
  }
}

@MainActor
public protocol StaticSpecimenCoordinatorType: SpecimenCoordinatorType where Destination: CaseIterable, Destination.AllCases: RandomAccessCollection { }
