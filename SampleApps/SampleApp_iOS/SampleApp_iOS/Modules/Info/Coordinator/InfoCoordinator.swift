//
//  InfoCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum InfoDestination: String, ScreenDestinationType {
  case last
}

@MainActor
final class InfoCoordinator<
  FactoryDelegateType: InfoCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, ScreenCoordinatorType, StackCoordinatorType {
  typealias DestinationType = InfoDestination
  
  let stackNavigator: StackNavigator<DestinationType>
  let factory: FactoryDelegateType

  init(
    stackNavigator: StackNavigator<DestinationType>,
    factory: FactoryDelegateType,
    onFinish: @escaping () -> Void
  ) {
    self.stackNavigator = stackNavigator
    self.factory = factory
    
    super.init(onFinish: onFinish)
  }
  
  func initialScreen() -> some View {
    factory.createFirstScreen(
      onContinue: { [weak self] in
        self?.showLastScreen()
      }
    )
    .onRemoveFromHierarchy(finish: self)
  }

  func screen(for destination: DestinationType) -> some View {
    switch destination {
    case .last:
      factory.createLastScreen(
        onDone: { [weak self] in
          self?.finish()
        }
      )
    }
  }

  private func showLastScreen() {
    stackNavigator.push(.last)
  }
}
