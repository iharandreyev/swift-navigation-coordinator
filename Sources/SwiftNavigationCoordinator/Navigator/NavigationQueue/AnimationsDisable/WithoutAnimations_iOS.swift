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
    job: @MainActor @escaping () -> Void
  ) async {
    if #available(iOS 18, *) {
      await self.run_new(perform: job)
    } else {
      await run_old(perform: job)
    }
  }
  
  @available(iOS, deprecated: 18, message: "Use Transaction-based solution for iOS 18+")
  @MainActor
  private func run_old(
    perform job: @MainActor @escaping () -> Void
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
    perform job: @MainActor @escaping () -> Void
  ) async  {
    var noAnimationTransaction = Transaction()
    noAnimationTransaction.disablesAnimations = true
    
    // Job does not throw, so `withTransaction` must also not throw
    try! withTransaction(noAnimationTransaction, job)
  }
}

#endif
