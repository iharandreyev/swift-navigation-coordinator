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
  @Test
  func appCoordinator_canHandleDeeplink_onlyWhen_main() async throws {
    let sut = AppCoordinator(
      navigator: Navigator.test(
        specimenDestination: AppDestination.appInit
      ),
      factory: AppCoordinatorFactoryDelegateMock.create()
    )
    
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.appInit)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), for: AppDestination.main)
    
    try await withTimeout(Constants.timeout) {
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
      navigator: Navigator.test(specimenDestination: MainTab.usecases),
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    let root = AppCoordinator(
      navigator: Navigator.test(specimenDestination: AppDestination.main),
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )
    
    try await withTimeout(Constants.timeout) { @MainActor in
      #warning("TODO: Figure out how to reduce this boilerplate")
      // Simulate view presentation
      _ = root.content(forSpecimen: .main)
      _ = main.content(forSpecimen: .usecases)
      await main.navigator.replaceSpecimenDestination(with: MainTab.deeplinks)
      _ = main.content(forSpecimen: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalSheet))
      #expect(main.navigator.specimenDestination() == MainTab.usecases)
      #expect(usecases.navigator.modalDestination() == .sheet(UsecasesDestination.Modal.modalSheet))
    }
  }
  
  @MainActor
  @Test
  func app_handles_showUsecasesAndModalCover() async throws {
    let usecases = UsecasesCoordinator()
    let main = MainCoordinator(
      navigator: Navigator.test(specimenDestination: MainTab.usecases),
      factory: MainCoordinatorFactoryDelegateMock.create(usecasesCoordinator: usecases)
    )
    let root = AppCoordinator(
      navigator: Navigator.test(specimenDestination: AppDestination.main),
      factory: AppCoordinatorFactoryDelegateMock.create(mainCoordinator: main)
    )

    try await withTimeout(Constants.timeout) { @MainActor in
      // Simulate view presentation
      _ = root.content(forSpecimen: .main)
      _ = main.content(forSpecimen: .usecases)
      await main.navigator.replaceSpecimenDestination(with: MainTab.deeplinks)
      _ = main.content(forSpecimen: .deeplinks)
      
      #expect(root.factory.createMainCoordinatorCalled)
      #expect(!root.factory.createAppInitScreenOnFinishCallbackVoidCalled)
      #expect(!root.factory.createOnboardingCoordinatorOnFinishCallbackVoidCalled)
      
      #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalCover))
      #expect(main.navigator.specimenDestination() == MainTab.usecases)
      #expect(usecases.navigator.modalDestination() == .cover(UsecasesDestination.Modal.modalCover))
    }
  }
  
  enum Constants {
    static let timeout = Duration.milliseconds(1500)
  }
}
