//
//  NavigationCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

@MainActor
public protocol NavigationCoordinatorType<
  SpecimenDestination,
  ModalDestination,
  StackDestination
>: CoordinatorBase {
  associatedtype SpecimenDestination: SomeDestination
  associatedtype ModalDestination: SomeDestination
  associatedtype StackDestination: SomeDestination
  
  associatedtype SpecimenDestinationContent: View
  associatedtype ModalDestinationContent: View
  associatedtype StackDestinationContent: View

  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> SpecimenDestinationContent
  @ViewBuilder
  func content(forModal destination: ModalDestination) -> ModalDestinationContent
  @ViewBuilder
  func content(forStack destination: StackDestination) -> StackDestinationContent
  
  associatedtype InitialContent: View
  
  @ViewBuilder
  func initialContent() -> InitialContent
}

@MainActor
extension NavigationCoordinatorType where SpecimenDestination == DestinationNever {
  @ViewBuilder
  public func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }
}

@MainActor
extension NavigationCoordinatorType where ModalDestination == DestinationNever {
  @ViewBuilder
  public func content(forModal destination: ModalDestination) -> some View {
    EmptyView()
  }
}

@MainActor
extension NavigationCoordinatorType where StackDestination == DestinationNever {
  @ViewBuilder
  public func content(forStack destination: StackDestination) -> some View {
    EmptyView()
  }
}
