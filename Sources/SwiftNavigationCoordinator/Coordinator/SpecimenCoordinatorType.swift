//
//  SpecimenCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol SpecimenCoordinatorType: NavigationCoordinatorType where SpecimenDestination: DestinationType {

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
  ) async {
    await navigator.replaceSpecimenDestination(
      with: destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
}
