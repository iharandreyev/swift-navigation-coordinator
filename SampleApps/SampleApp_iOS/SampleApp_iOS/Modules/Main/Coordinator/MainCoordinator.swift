//
//  MainCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MainTab: String, DestinationType, CaseIterable {
  case usecases
  case deeplinks
}

@MainActor
final class MainCoordinator<
  FactoryDelegateType: MainCoordinatorFactoryDelegateType
>: CoordinatorBase, StaticSpecimenCoordinatorType, LabelledSpecimenCoordinatorType {
  let factory: FactoryDelegateType
  
  init(
    navigator: Navigator,
    factory: FactoryDelegateType
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: nil)
  }
  
  // MARK: - Navigation Coordinator
  
  typealias SpecimenDestination = MainTab
  typealias ModalDestination = DestinationNever
  typealias StackDestination = DestinationNever
  
  func initialContent() -> some View {
    CoordinatedScreen.tabbed(
      coordinator: self
    )
  }

  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    switch destination {
    case .usecases:
      CoordinatedScreen.stackRoot(
        modalCoordinator: addChild(
          for: destination,
          factory.createUsecasesCoordinator
        )
      )
    case .deeplinks:
      CoordinatedScreen.base(
        coordinator: addChild(
          for: destination,
          factory.createDeeplinksCoordinator
        )
      )
    }
  }
  
  @ViewBuilder
  func label(forSpecimen destination: SpecimenDestination) -> some View {
    switch destination {
    case .usecases:
      Label("Usecases", systemImage: "folder.fill")
    case .deeplinks:
      Label("Deeplinks", systemImage: "gear")
      #warning("TODO: Figure out how to implement custom label using default iOS 16 TabView")
//      VStack {
//        Image(systemName: "gear")
//        Text("Settings")
//      }
//      .overlay(alignment: .bottomTrailing) {
//        Circle().fill(Color.red).frame(width: 10, height: 10)
//      }
    }
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    EmptyView()
  }
  
  // MARK: - Deeplink
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    switch deeplink {
    case Deeplink.showUsecases:
      await replaceSpecimenDestination(with: .usecases)
      return .done
      
    case
      Deeplink.showUsecasesAndModalCover,
      Deeplink.showUsecasesAndModalSheet,
      Deeplink.showUsecasesAndPushScreen,
      Deeplink.showMultiChildPathA,
      Deeplink.showMultiChildPathAFinish,
      Deeplink.showMultiChildPathB,
      Deeplink.showMultiChildPathBFinish:
      
      await replaceSpecimenDestination(with: .usecases)
      return .partial
      
    default:
      return .impossible
    }
  }
}
