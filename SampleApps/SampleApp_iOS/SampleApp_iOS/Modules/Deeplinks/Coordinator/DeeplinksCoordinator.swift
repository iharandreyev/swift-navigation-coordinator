//
//  DeeplinksCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

final class DeeplinksCoordinator: CoordinatorBase, NavigationCoordinatorType {
  // MARK: - Navigation Coordinator
  
  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = DestinationNever
  typealias StackDestination = DestinationNever
  
  func initialContent() -> some View {
    DeeplinksListScreen()
  }
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    EmptyView()
  }
}
