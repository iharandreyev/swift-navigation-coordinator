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
  typealias Destination = InfoDestination

  let factory: FactoryDelegateType

  init(
    navigator: Navigator,
    factory: FactoryDelegateType,
    onFinish: Callback<Void>
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: onFinish)
  }
  
  func initialScreen() -> some View {
    factory.createFirstScreen(
      onContinue: Callback { [unowned self] in
        await showLastScreen()
      }
    )
  }

  func screen(for destination: Destination) -> some View {
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
    await navigator.push(Destination.last)
  }
}
