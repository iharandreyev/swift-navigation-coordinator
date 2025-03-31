//
//  SpecimenCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol SpecimenCoordinatorType: CoordinatorBase {
  associatedtype DestinationType: ScreenDestinationType
  associatedtype DestinationScreenContentType: View
  
  var specimenNavigator: SpecimenNavigator<DestinationType> { get }
  
  @ViewBuilder
  func screenContent(for destination: DestinationType) -> DestinationScreenContentType
  func screenTransition(for destination: DestinationType) -> AnyTransition
}

extension SpecimenCoordinatorType {
  public func screen(
    for destination: DestinationType
  ) -> some View {
    screenContent(
      for: destination
    )
    .transition(
      screenTransition(for: destination)
    )
    .id(destination)
  }
  
  public func screenTransition(for destination: DestinationType) -> AnyTransition {
    .opacity
  }
}

@MainActor
public protocol StaticSpecimenCoordinatorType: SpecimenCoordinatorType where DestinationType: CaseIterable, DestinationType.AllCases: RandomAccessCollection { }
