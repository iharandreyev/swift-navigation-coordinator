//
//  SpecimenCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol SpecimenCoordinatorType: CoordinatorBase {
  associatedtype SpecimenDestination: SomeDestination
  associatedtype SpecimenDestinationScreen: View

  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> SpecimenDestinationScreen
  func transition(forSpecimen destination: SpecimenDestination) -> AnyTransition
}

extension SpecimenCoordinatorType {
  public func screen(
    forSpecimen destination: SpecimenDestination
  ) -> some View {
    content(
      forSpecimen: destination
    )
    .transition(
      transition(forSpecimen: destination)
    )
    .id(destination)
  }
  
  public func transition(forSpecimen destination: SpecimenDestination) -> AnyTransition {
    .opacity
  }
}

@MainActor
public protocol StaticSpecimenCoordinatorType: SpecimenCoordinatorType where SpecimenDestination: CaseIterable, SpecimenDestination.AllCases: RandomAccessCollection { }

@MainActor
public protocol LabelledSpecimenCoordinatorType: SpecimenCoordinatorType {
  associatedtype SpecimenDestinationScreenLabel: View
  
  @ViewBuilder
  func label(forSpecimen destination: SpecimenDestination) -> SpecimenDestinationScreenLabel
}

extension SpecimenCoordinatorType {
  public func replaceSpecimenDestination(
    with destination: SpecimenDestination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where SpecimenDestination: DestinationType {
    await navigator.replaceSpecimenDestination(
      with: destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
}
