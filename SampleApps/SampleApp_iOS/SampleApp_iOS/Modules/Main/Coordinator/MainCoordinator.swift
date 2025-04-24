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
>: CoordinatorBase, CoordinatorType, StaticSpecimenCoordinatorType, LabelledSpecimenCoordinatorType {
  typealias Destination = MainTab
  
  let factory: FactoryDelegateType
  
  init(
    navigator: Navigator,
    factory: FactoryDelegateType
  ) {
    self.factory = factory
    
    super.init(navigator: navigator, onFinish: nil)
  }
  
  func screenContent(for destination: Destination) -> some View {
    switch destination {
    case .usecases:
      CoordinatedScreen.stackRoot(
        modalCoordinator: addChild(
          childFactory: {
            factory.createUsecasesCoordinator()
          },
          as: MainTab.usecases
        )
      )
    case .deeplinks:
      CoordinatedScreen.base(
        coordinator: addChild(
          childFactory: {
            factory.createDeeplinksCoordinator()
          },
          as: MainTab.deeplinks
        )
      )
    }
  }
  
  func label(for destination: Destination) -> some View {
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
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    switch deeplink {
    case Deeplink.showUsecases:
      await navigator.replaceSpecimenDestination(with: Destination.usecases)
      return .done
      
    case
      Deeplink.showUsecasesAndModalCover,
      Deeplink.showUsecasesAndModalSheet,
      Deeplink.showUsecasesAndPushScreen,
      Deeplink.showMultiChildPathA,
      Deeplink.showMultiChildPathAFinish,
      Deeplink.showMultiChildPathB,
      Deeplink.showMultiChildPathBFinish:
      
      await navigator.replaceSpecimenDestination(with: Destination.usecases)
      return .partial
      
    default:
      return .impossible
    }
  }
}
