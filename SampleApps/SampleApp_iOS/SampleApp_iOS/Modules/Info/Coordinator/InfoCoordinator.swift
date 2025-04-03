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
    onFinish: Callback<Void>
  ) {
    self.stackNavigator = stackNavigator
    self.factory = factory
    
    super.init(onFinish: onFinish)
  }
  
  func initialScreen() -> some View {
    factory.createFirstScreen(
      onContinue: Callback { [unowned self] in
        await showLastScreen()
      }
    )
    .onRemoveFromHierarchy(finish: self)
  }

  func screen(for destination: DestinationType) -> some View {
    switch destination {
    case .last:
      factory.createLastScreen(
        onDone: Callback { [weak self] in
          await self?.finish()
        }
      )
    }
  }

  func showLastScreen() async {
    await stackNavigator.push(.last)
  }
}
