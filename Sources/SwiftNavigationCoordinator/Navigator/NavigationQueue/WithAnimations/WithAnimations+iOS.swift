//
//  WithAnimations+iOS.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if os(iOS)

import Clocks
import SwiftUI
import UIKit

#warning("TODO: Fix delays")
actor WithAnimations_iOS {
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
    await withCheckedContinuation { [clock] continuation in
      CATransaction.begin()
      CATransaction.setCompletionBlock {
        // This completion is invoked too early
        continuation.resume()
      }
      
      withAnimation(.default) {
        job()
      }
      
      CATransaction.commit()
    }
    
    await clock.trySleep(for: DelayDuration.frame)
  }
  
  @available(iOS 18, *)
  @MainActor
  private func run_new(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    await withCheckedContinuation { [clock] continuation in
      var transaction = Transaction()
      transaction.addAnimationCompletion {
        // This completion is invoked too early
        continuation.resume()
      }
      transaction.animation = .default

      withTransaction(transaction) {
        job()
      }
    }
    
    await clock.trySleep(for: DelayDuration.frame)
  }
}

#endif
