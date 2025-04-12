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
    let navigator = SpecimenNavigator(
      initialDestination: AppDestination.appInit
    )
    let sut = AppCoordinator(
      specimenNavigator: navigator,
      factory: AppCoordinatorFactoryDelegateMockDummy()
    )
    
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.appInit)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(processDeeplinkResult: .done), as: AppDestination.main)
    
    for deeplink in Deeplink.allCases {
      await navigator.replaceDestination(with: .appInit)
      #expect(await sut.handleDeeplink(deeplink) == false)
      await navigator.replaceDestination(with: .onboarding)
      #expect(await sut.handleDeeplink(deeplink) == false)
      await navigator.replaceDestination(with: .main)
      #expect(await sut.handleDeeplink(deeplink) == true)
    }
  }
  
  @Test
  func app_handles_showUsecasesAndModalSheet() async throws {
    let usecasesModalNavigator = ModalNavigator<UsecasesDestination>()
    let usecases = UsecasesCoordinator(modalNavigator: usecasesModalNavigator)
    
    let mainNavigator = SpecimenNavigator(
      initialDestination: MainTab.usecases
    )
    let main = MainCoordinator(
      specimenNavigator: mainNavigator,
      factory: MainCoordinatorFactoryDelegateMock(
        createUsecasesCoordinator: { _ in usecases },
        createDeeplinksCoordinator: { _ in DummyCoordinator() }
      )
    )
    
    let rootNavigator = SpecimenNavigator(
      initialDestination: AppDestination.main
    )
    let root = AppCoordinator(
      specimenNavigator: rootNavigator,
      factory: AppCoordinatorFactoryDelegateMock(
        createOnboardingCoordinator: { _ in DummyCoordinator() },
        createMainCoordinator: { _ in main }
      )
    )
    
    #warning("TODO: Figure out how to reduce this boilerplate")
    // Simulate view presentation
    _ = root.screenContent(for: .main)
    _ = main.screenContent(for: .usecases)
    await mainNavigator.replaceDestination(with: .deeplinks)
    _ = main.screenContent(for: .deeplinks)
    
    #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalSheet))
    #expect(mainNavigator.destination == .usecases)
    #expect(usecasesModalNavigator.destination == .sheet(.modalSheet))
  }
  
  @Test
  func app_handles_showUsecasesAndModalCover() async throws {
    let usecasesModalNavigator = ModalNavigator<UsecasesDestination>()
    let usecases = UsecasesCoordinator(modalNavigator: usecasesModalNavigator)
    
    let mainNavigator = SpecimenNavigator(
      initialDestination: MainTab.usecases
    )
    let main = MainCoordinator(
      specimenNavigator: mainNavigator,
      factory: MainCoordinatorFactoryDelegateMock(
        createUsecasesCoordinator: { _ in usecases },
        createDeeplinksCoordinator: { _ in DummyCoordinator() }
      )
    )
    
    let rootNavigator = SpecimenNavigator(
      initialDestination: AppDestination.main
    )
    let root = AppCoordinator(
      specimenNavigator: rootNavigator,
      factory: AppCoordinatorFactoryDelegateMock(
        createOnboardingCoordinator: { _ in DummyCoordinator() },
        createMainCoordinator: { _ in main }
      )
    )

    // Simulate view presentation
    _ = root.screenContent(for: .main)
    _ = main.screenContent(for: .usecases)
    await mainNavigator.replaceDestination(with: .deeplinks)
    _ = main.screenContent(for: .deeplinks)
    
    #expect(await root.handleDeeplink(Deeplink.showUsecasesAndModalCover))
    #expect(mainNavigator.destination == .usecases)
    #expect(usecasesModalNavigator.destination == .cover(.modalCover))
  }
}
