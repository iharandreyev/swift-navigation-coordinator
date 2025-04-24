//
//  DeeplinkTests.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting
import SwiftUI
import Testing

@testable
import SampleApp_iOS

@MainActor
struct DeeplinkTests {
  init() {
    SwiftNavigationCoordinator.setEnvironment(.test)
  }
  
  @Test
  func appCoordinator_canHandleDeeplink_onlyWhen_main() async throws {
    let navigator = SpecimenNavigator(
      initialDestination: AppDestination.appInit
    )
    let sut = AppCoordinator(
      navigator: navigator,
      factory: AppCoordinatorFactoryDelegateMock.create()
    )
    
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.appInit)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.main)
    
    try await withTimeout(.seconds(1)) {
      for deeplink in Deeplink.allCases {
        await navigator.replaceSpecimenDestination(with: Destination.appInit)
        #expect(await sut.handleDeeplink(deeplink) == false)
        await navigator.replaceSpecimenDestination(with: Destination.onboarding)
        #expect(await sut.handleDeeplink(deeplink) == false)
        await navigator.replaceSpecimenDestination(with: Destination.main)
        #expect(await sut.handleDeeplink(deeplink) == true)
      }
    }
  }
  
  @MainActor
  @Test
  func app_handles_showUsecasesAndModalSheet() async throws {
    let usecasesModalNavigator = ModalNavigator<UsecasesDestination>()
    let usecases = UsecasesCoordinator(navigator: usecasesModalNavigator)
    
    let mainNavigator = SpecimenNavigator(
      initialDestination: MainTab.usecases
    )
    let main = MainCoordinator(
      navigator: mainNavigator,
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    
    let rootNavigator = SpecimenNavigator(
      initialDestination: AppDestination.main
    )
    let root = AppCoordinator(
      navigator: rootNavigator,
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )
    
    try await withTimeout(.seconds(1)) { @MainActor in
      #warning("TODO: Figure out how to reduce this boilerplate")
      // Simulate view presentation
      _ = root.screenContent(for: .main)
      _ = main.screenContent(for: .usecases)
      await mainNavigator.replaceSpecimenDestination(with: .deeplinks)
      _ = main.screenContent(for: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalSheet))
      #expect(await mainNavigator.destination == .usecases)
      #expect(await usecasesModalNavigator.destination == .sheet(.modalSheet))
    }
  }
  
  @MainActor
  @Test
  func app_handles_showUsecasesAndModalCover() async throws {
    let usecasesModalNavigator = ModalNavigator<UsecasesDestination>()
    let usecases = UsecasesCoordinator(navigator: usecasesModalNavigator)
    
    let mainNavigator = SpecimenNavigator(
      initialDestination: MainTab.usecases
    )
    let main = MainCoordinator(
      navigator: mainNavigator,
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    
    let rootNavigator = SpecimenNavigator(
      initialDestination: AppDestination.main
    )
    let root = AppCoordinator(
      navigator: rootNavigator,
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )

    try await withTimeout(.seconds(1)) { @MainActor in
      // Simulate view presentation
      _ = root.screenContent(for: .main)
      _ = main.screenContent(for: .usecases)
      await mainNavigator.replaceSpecimenDestination(with: .deeplinks)
      _ = main.screenContent(for: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalCover))
      #expect(await mainNavigator.destination == .usecases)
      #expect(await usecasesModalNavigator.destination == .cover(.modalCover))
    }
  }
}
