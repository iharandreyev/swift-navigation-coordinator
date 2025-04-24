//
//  UsecasesCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum UsecasesDestination {
  enum Modal: String, DestinationType {
    case modalSheet
    case modalCover
  }
  
  enum Stack: String, DestinationType {
    case pushedScreen
    case multiChildFlow
  }
}

final class UsecasesCoordinator: CoordinatorBase, NavigationCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
  // MARK: - Navigation Coordinator

  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = UsecasesDestination.Modal
  typealias StackDestination = UsecasesDestination.Stack

  func initialContent() -> some View {
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
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
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
    }
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    switch destination {
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
            of: MultiChildFlowCoordinator.self,
            for: destination
          )
        )
    }
  }

  // MARK: - Logic
  
  private func showModalSheet() async {
    await presentDestination(.sheet(.modalSheet))
  }
  
  private func showModalCover() async {
    await presentDestination(.cover(.modalCover))
  }
  
  private func showPushedScreen() async {
    await replacePath(with: .pushedScreen)
  }
  
  private func showMultiChildFlow() async {
    let destination = StackDestination.multiChildFlow
    
    addChild(
      for: destination
    ) { navigator in
      MultiChildFlowCoordinator(
        navigator: navigator,
        onFinish: Callback { [unowned self] in
          await multiChildFlowDidFinish()
        }
      )
    }
    
    await replacePath(with: destination)
  }

  func multiChildFlowDidFinish() async {
    await popToRoot()
  }
    
  // MARK: - Deeplink

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
