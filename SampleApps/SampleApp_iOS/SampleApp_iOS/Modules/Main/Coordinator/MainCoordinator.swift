//
//  MainCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MainTab: ScreenDestinationType, CaseIterable {
  case usecases
  case deeplinks
}

@MainActor
final class MainCoordinator<
  FactoryDelegateType: MainCoordinatorFactoryDelegateType
>: CoordinatorBase, CoordinatorType, StaticSpecimenCoordinatorType, LabelledSpecimenCoordinatorType {
  typealias DestinationType = MainTab
  
  let specimenNavigator: SpecimenNavigator<MainTab>
  let factory: FactoryDelegateType
  
  init(
    specimenNavigator: SpecimenNavigator<MainTab>,
    factory: FactoryDelegateType
  ) {
    self.specimenNavigator = specimenNavigator
    self.factory = factory
    
    super.init(onFinish: nil)
  }
  
  func screenContent(for destination: DestinationType) -> some View {
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
  
  func label(for destination: DestinationType) -> some View {
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
  ) -> ProcessDeeplinkResult {
    switch deeplink {
    case Deeplink.showUsecases:
      specimenNavigator.replaceDestination(with: .usecases)
      return .done
      
    case
      Deeplink.showUsecasesAndModalCover,
      Deeplink.showUsecasesAndModalSheet:
      
      specimenNavigator.replaceDestination(with: .usecases)
      return .partial
      
    default:
      return .impossible
    }
  }
}
