//
//  MainCoordinatorFactoryDelegateMock.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftNavigationCoordinatorTesting
import SwiftUI

@testable
import SampleApp_iOS

#warning("TODO: Implement macro for this")
@MainActor
final class MainCoordinatorFactoryDelegateMock: MainCoordinatorFactoryDelegateType {
  struct Params_createUsecasesCoordinator { }
  
  private(set) var createUsecasesCoordinator_invocations: [Params_createUsecasesCoordinator] = []
  var createUsecasesCoordinator_count: Int { createUsecasesCoordinator_invocations.count }
  private let createUsecasesCoordinator_invoked: ((Params_createUsecasesCoordinator) -> Void)?
  private var createUsecasesCoordinator_onFinish: (() -> Void)!
  
  func createUsecasesCoordinator() -> DummyCoordinator {
    let params = Params_createUsecasesCoordinator()
    
    createUsecasesCoordinator_invocations.append(params)
    createUsecasesCoordinator_invoked?(params)
    
    return DummyCoordinator()
  }
  
  struct Params_createDeeplinksCoordinator { }
  
  private(set) var createDeeplinksCoordinator_invocations: [Params_createDeeplinksCoordinator] = []
  var createDeeplinksCoordinator_count: Int { createDeeplinksCoordinator_invocations.count }
  private let createDeeplinksCoordinator_invoked: ((Params_createDeeplinksCoordinator) -> Void)?
  private var createDeeplinksCoordinator_onFinish: (() -> Void)!
  
  func createDeeplinksCoordinator() -> DummyCoordinator {
    let params = Params_createDeeplinksCoordinator()
    
    createDeeplinksCoordinator_invocations.append(params)
    createDeeplinksCoordinator_invoked?(params)
    
    return DummyCoordinator()
  }
  
  init(
    createUsecasesCoordinator_invoked: ((Params_createUsecasesCoordinator) -> Void)? = nil,
    createDeeplinksCoordinator_invoked: ((Params_createDeeplinksCoordinator) -> Void)? = nil
  ) {
    self.createUsecasesCoordinator_invoked = createUsecasesCoordinator_invoked
    self.createDeeplinksCoordinator_invoked = createDeeplinksCoordinator_invoked
  }
}
