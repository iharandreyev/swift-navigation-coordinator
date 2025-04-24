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
    let sut = AppCoordinator(
      navigator: Navigator(
        initialSpecimenDestination: AppDestination.appInit
      ),
      factory: AppCoordinatorFactoryDelegateMock.create()
    )
    
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.appInit)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.main)
    
    try await withTimeout(.seconds(1)) {
      for deeplink in Deeplink.allCases {
        await sut.navigator.replaceSpecimenDestination(with: AppDestination.appInit)
        #expect(await sut.handleDeeplink(deeplink) == false)
        await sut.navigator.replaceSpecimenDestination(with: AppDestination.onboarding)
        #expect(await sut.handleDeeplink(deeplink) == false)
        await sut.navigator.replaceSpecimenDestination(with: AppDestination.main)
        #expect(await sut.handleDeeplink(deeplink) == true)
      }
    }
  }
  
  @MainActor
  @Test
  func app_handles_showUsecasesAndModalSheet() async throws {
    let usecases = UsecasesCoordinator()
    let main = MainCoordinator(
      navigator: Navigator(initialSpecimenDestination: MainTab.usecases),
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    let root = AppCoordinator(
      navigator: Navigator(initialSpecimenDestination: AppDestination.main),
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )
    
    try await withTimeout(.seconds(1)) { @MainActor in
      #warning("TODO: Figure out how to reduce this boilerplate")
      // Simulate view presentation
      _ = root.screenContent(for: .main)
      _ = main.screenContent(for: .usecases)
      await main.navigator.replaceSpecimenDestination(with: MainTab.deeplinks)
      _ = main.screenContent(for: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalSheet))
      #expect(main.navigator.specimenDestination() == MainTab.usecases)
      #expect(usecases.navigator.modalDestination() == .sheet(UsecasesDestination.modalSheet))
    }
  }
  
  @MainActor
  @Test
  func app_handles_showUsecasesAndModalCover() async throws {
    let usecases = UsecasesCoordinator()
    let main = MainCoordinator(
      navigator: Navigator(initialSpecimenDestination: MainTab.usecases),
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    let root = AppCoordinator(
      navigator: Navigator(initialSpecimenDestination: AppDestination.main),
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )

    try await withTimeout(.seconds(1)) { @MainActor in
      // Simulate view presentation
      _ = root.screenContent(for: .main)
      _ = main.screenContent(for: .usecases)
      await main.navigator.replaceSpecimenDestination(with: MainTab.deeplinks)
      _ = main.screenContent(for: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalCover))
      #expect(main.navigator.specimenDestination() == MainTab.usecases)
      #expect(usecases.navigator.modalDestination() == .cover(UsecasesDestination.modalCover))
    }
  }
}
