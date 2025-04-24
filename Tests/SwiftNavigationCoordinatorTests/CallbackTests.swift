//
//  CallbackTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import SwiftNavigationCoordinatorTesting
import Testing

@testable
import SwiftNavigationCoordinator

struct CallbackTests {
  @Test
  func callback_invokesOnCompleted_whenObservedAfter_callAsFunction() async throws {
    try await withTimeout(Constants.timeout) {
      let completion = createSut()
      
      completion()
      
      await completion.onCompleted()
    }
  }
  
  @Test
  func callback_invokesOnCompleted_whenObservedBefore_callAsFunction() async throws {
    try await withTimeout(Constants.timeout) {
      let completion = createSut()
      
      Task.detached {
        try await Task.sleep(for: Constants.sutInvocationDelay)
        completion()
      }
      
      await completion.onCompleted()
    }
  }
  
  @Test
  func callback_invokesOnCompleted_whenObservedBefore_execute() async throws {
    try await withTimeout(Constants.timeout) {
      let completion = createSut()
      
      Task.detached {
        try await Task.sleep(for: Constants.sutInvocationDelay)
        await completion.execute()
      }
      
      await completion.onCompleted()
    }
  }
  
  private func createSut() -> Callback<Void> {
    Callback {
      try! await Task.sleep(for: Constants.sutJobDuration)
    }
  }
}

private enum Constants {
  static let sutJobDuration = Duration.milliseconds(1)
  static let sutInvocationDelay = sutJobDuration * 3
  static let timeout = Duration.seconds(3)
}
