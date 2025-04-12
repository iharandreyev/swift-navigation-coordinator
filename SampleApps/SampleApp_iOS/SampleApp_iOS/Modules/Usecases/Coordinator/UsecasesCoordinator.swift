//
//  UsecasesCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum UsecasesDestination: String, ModalDestinationContentType {
  case modalSheet
  case modalCover
  case pushedScreen
  case multiChildFlow
  
  var id: String { rawValue }
}

final class UsecasesCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType, CoordinatorChildSearch {
  typealias DestinationType = UsecasesDestination
  
  let stackNavigator: StackNavigator<DestinationType>
  let modalNavigator: ModalNavigator<DestinationType>
  
  init(
    stackNavigator: StackNavigator<DestinationType> = StackNavigator(),
    modalNavigator: ModalNavigator<DestinationType> = ModalNavigator()
  ) {
    self.stackNavigator = stackNavigator
    self.modalNavigator = modalNavigator
  }
  
  func initialScreen() -> some View {
    UsecasesListScreen(
      onShowModalSheet: { [unowned self] in
        Task(operation: showModalSheet)
      },
      onShowModalCover: { [unowned self] in
        Task(operation: showModalCover)
      },
      onShowPushedScreen: { [unowned self] in
        Task(operation: showPushedScreen)
      },
      onShowMultiChildFlow: { [unowned self] in
        Task(operation: showMultiChildFlow)
      }
    )
  }
  
  func screen(for destination: DestinationType) -> some View {
    switch destination {
    case .modalSheet:
      SomeScreen(
        name: "a modal",
        description: "a screen that is presented as a modal sheet",
        content: {
          DismissButton()
        }
      )
      .id(destination)
      
    case .modalCover:
      SomeScreen(
        name: "a modal",
        description: "a screen that is presented as a full screen cover",
        content: {
          DismissButton()
        }
      )
      .id(destination)

    case .pushedScreen:
      SomeScreen(
        name: "a pushed screen",
        description: "a screen that is pushed into stack",
        content: {
          DismissButton()
        }
      )
      .id(destination)

    case .multiChildFlow:
      CoordinatedScreen
        .stackPage(
          stackCoordinator: child(
            ofType: MultiChildFlowCoordinator.self,
            for: destination
          )
        )
    }
  }
  
  private func showModalSheet() async {
    await modalNavigator.presentDestination(.sheet(.modalSheet))
  }
  
  private func showModalCover() async {
    await modalNavigator.presentDestination(.cover(.modalCover))
  }
  
  private func showPushedScreen() async {
    await stackNavigator.push(.pushedScreen)
  }
  
  private func showMultiChildFlow() async {
    let destination = DestinationType.multiChildFlow
    
    addChild(
      childFactory: {
        MultiChildFlowCoordinator(
          stackNavigator: stackNavigator.scope(),
          onFinish: Callback { [unowned self] in
            await multiChildFlowDidFinish()
          }
        )
      },
      as: destination
    )
    
    await stackNavigator.push(destination)
  }


  func multiChildFlowDidFinish() async {
    await stackNavigator.popToRoot()
  }

  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    #warning("TODO: Ensure coordinator is in the correct state prior to firing navigation logic")
    switch deeplink {
    case Deeplink.showUsecasesAndModalCover:
      await showModalCover()
      return .done
      
    case Deeplink.showUsecasesAndModalSheet:
      await showModalSheet()
      return .done
      
    case Deeplink.showUsecasesAndPushScreen:
      await showPushedScreen()
      return .done
      
    case
      Deeplink.showMultiChildPathA,
      Deeplink.showMultiChildPathAFinish,
      Deeplink.showMultiChildPathB,
      Deeplink.showMultiChildPathBFinish:
      
      await showMultiChildFlow()
      return .partial
      
    default:
      return .impossible
    }
  }
}
