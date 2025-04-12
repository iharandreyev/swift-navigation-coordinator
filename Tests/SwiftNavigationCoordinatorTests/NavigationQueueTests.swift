//
//  NavigationQueueTests.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import Clocks
import SwiftNavigationCoordinatorTesting
import Testing

@testable
import SwiftNavigationCoordinator

struct NavigationQueueTests {
  @Test
  func navigationQueue_scheduleSingle_finishesWhenAnimated() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await createSut()
      
      await sut.schedule(
        uiUpdate: { },
        animated: true
      )
      
      #expect(await sut.queueLength == 0)
    }
  }
  
  @Test
  func navigationQueue_scheduleSingle_finishesWhenNotAnimated() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await createSut()
      
      await sut.schedule(
        uiUpdate: { },
        animated: false
      )
      
      #expect(await sut.queueLength == 0)
    }
  }
  
  @Test
  func navigationQueue_scheduleMultiple_finishesWhenAnimated() async throws {
    try await withTimeout(.seconds(1)) {
      let sut = await createSut()
      
      await withTaskGroup(of: Void.self) { taskGroup in
        for _ in 0 ..< 10 {
          taskGroup.addTask {
            await sut.schedule(
              uiUpdate: { },
              animated: true
            )
          }
        }
      }
      
      #expect(await sut.queueLength == 0)
    }
  }
  
  func createSut() async -> NavigationQueue {
    NavigationQueue(clock: ImmediateClock())
  }
}
