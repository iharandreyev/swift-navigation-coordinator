//
//  UsecasesCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum UsecasesDestination: String, DestinationType {
  case modalSheet
  case modalCover
  case pushedScreen
  case multiChildFlow
  
  var id: String { rawValue }
}

final class UsecasesCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType, CoordinatorChildSearch {
  typealias Destination = UsecasesDestination
  
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
  
  func screen(for destination: Destination) -> some View {
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
    await navigator.presentDestination(.sheet(Destination.modalSheet))
  }
  
  private func showModalCover() async {
    await navigator.presentDestination(.cover(Destination.modalCover))
  }
  
  private func showPushedScreen() async {
    await navigator.push(Destination.pushedScreen)
  }
  
  private func showMultiChildFlow() async {
    let destination = Destination.multiChildFlow
    
    addChild(
      childFactory: {
        MultiChildFlowCoordinator(
          navigator: Navigator.continue(navigator),
          onFinish: Callback { [unowned self] in
            await multiChildFlowDidFinish()
          }
        )
      },
      as: destination
    )
    
    await navigator.push(destination)
  }


  func multiChildFlowDidFinish() async {
    await navigator.popToRoot()
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
