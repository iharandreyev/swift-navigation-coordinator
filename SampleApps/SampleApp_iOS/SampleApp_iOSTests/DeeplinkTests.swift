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
      factory: AppCoordinatorFactoryDelegateMockMinimal()
    )
    
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.appInit)
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.onboarding)
    sut.addChild(DummyCoordinator(canHandleDeeplinks: true), as: AppDestination.main)
    
    Deeplink.allCases.forEach {
      navigator.replaceDestination(with: .appInit)
      #expect(sut.handleDeeplink($0) == false)
      navigator.replaceDestination(with: .onboarding)
      #expect(sut.handleDeeplink($0) == false)
      navigator.replaceDestination(with: .main)
      #expect(sut.handleDeeplink($0) == true)
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
    mainNavigator.replaceDestination(with: .deeplinks)
    _ = main.screenContent(for: .deeplinks)
    
    #expect(root.handleDeeplink(Deeplink.showUsecasesAndModalSheet))
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
    mainNavigator.replaceDestination(with: .deeplinks)
    _ = main.screenContent(for: .deeplinks)
    
    #expect(root.handleDeeplink(Deeplink.showUsecasesAndModalCover))
    #expect(mainNavigator.destination == .usecases)
    #expect(usecasesModalNavigator.destination == .cover(.modalCover))
  }
}
