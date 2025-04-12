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
  
  var id: String { rawValue }
}

final class UsecasesCoordinator: CoordinatorBase, ScreenCoordinatorType, StackCoordinatorType, ModalCoordinatorType {
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
    }
  }
  
  private func showModalSheet() async {
    await modalNavigator.presentDestination(.sheet(.modalSheet))
  }
  
  private func showModalCover() async {
    await modalNavigator.presentDestination(.cover(.modalCover))
  }
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    switch deeplink {
    case Deeplink.showUsecasesAndModalCover:
      await showModalCover()
      return .done
      
    case Deeplink.showUsecasesAndModalSheet:
      await showModalSheet()
      return .done
      
    default:
      return .impossible
    }
  }
}
