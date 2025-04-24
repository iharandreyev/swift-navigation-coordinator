//
//  InfoCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum InfoDestination: String, DestinationType {
  case last
}

@MainActor
final class InfoCoordinator<
  FactoryDelegateType: InfoCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, ScreenCoordinatorType, StackCoordinatorType {
  let factory: FactoryDelegateType

  init(
    navigator: Navigator,
    factory: FactoryDelegateType,
    onFinish: Callback<Void>
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: onFinish)
  }
  
  // MARK: - Navigation Coordinator
  
  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = DestinationNever
  typealias StackDestination = InfoDestination
  
  func initialScreen() -> some View {
    factory.createFirstScreen(
      onContinue: Callback { [unowned self] in
        await showLastScreen()
      }
    )
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
    switch destination {
    case .last:
      factory.createLastScreen(
        onDone: Callback { [weak self] in
          await self?.finish()
        }
      )
    }
  }
  
  // MARK: - Logic

  func showLastScreen() async {
    await push(.last)
  }
}
