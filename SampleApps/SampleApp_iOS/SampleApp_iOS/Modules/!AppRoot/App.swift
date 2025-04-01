//
//  App.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftNavigationCoordinator
import SwiftUI

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self)
  private var appDelegate
  
  private let coordinator: AppCoordinator<AppCoordinatorFactoryDelegate>

  init() {
    coordinator = AppCoordinator(
      specimenNavigator: SpecimenNavigator<AppDestination>(initialDestination: .appInit),
      factory: AppCoordinatorFactoryDelegate()
    )
    
    appDelegate.onHandleDeeplink = { [unowned coordinator] deeplink in
      Task.detached { [coordinator] in
        await coordinator.handleDeeplink(deeplink)
      }
      #warning("TODO: Figure out what to do here")
      return true
    }
  }
  
  var body: some Scene {
    WindowGroup {
      AppRoot(coordinator: coordinator)
    }
    .environment(\.urlOpener, UIApplicationURLOpener())
  }
}
