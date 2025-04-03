//
//  WithoutAnimations_iOS.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if os(iOS)

import Clocks
import SwiftUI
import UIKit

actor WithoutAnimations_iOS {
  let clock: AnyClock<Duration>
  
  init(
    clock: AnyClock<Duration>
  ) {
    self.clock = clock
  }
  
  func run(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async {
    if #available(iOS 18, *) {
      await run_new(job)
    } else {
      await run_old(job)
    }
  }
  
  @available(iOS, deprecated: 18, message: "Use Transaction-based solution for iOS 18+")
  @MainActor
  private func run_old(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    let stepEndDelay = DelayDuration.frame
    
    UIDisable.setUiDisabled(true)
    await clock.trySleep(for: stepEndDelay)
    
    UIView.setAnimationsEnabled(false)
    await clock.trySleep(for: stepEndDelay)
    
    job()
    await clock.trySleep(for: stepEndDelay)
    
    UIView.setAnimationsEnabled(true)
    await clock.trySleep(for: stepEndDelay)
    
    UIDisable.setUiDisabled(false)
  }
  
  @available(iOS 18, *)
  @MainActor
  private func run_new(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    var noAnimationTransaction = Transaction()
    noAnimationTransaction.disablesAnimations = true

    withTransaction(noAnimationTransaction) {
      job()
    }
  }
}

#endif
