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

actor WithAnimations_iOS {
  let clock: AnyClock<Duration>
  
  init(
    clock: AnyClock<Duration>
  ) {
    self.clock = clock
  }
  
  func run(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation
  ) async {
    if #available(iOS 18, *) {
      await run_new(job, animation: animation)
    } else {
      await run_old(job, animation: animation)
    }
  }
  
  @available(iOS, deprecated: 18, message: "Use Transaction-based solution for iOS 18+")
  @MainActor
  private func run_old(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation
  ) async  {
    await withCheckedContinuation { continuation in
      CATransaction.begin()
      CATransaction.setCompletionBlock {
        continuation.resume()
      }
      
      withAnimation(animation) {
        job()
      }
      
      CATransaction.commit()
    }
    
    await clock.trySleep(for: DelayDuration.frame)
  }
  
  @available(iOS 18, *)
  @MainActor
  private func run_new(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation
  ) async  {
    await withCheckedContinuation { continuation in
      var transaction = Transaction()
      transaction.addAnimationCompletion {
        continuation.resume()
      }
      transaction.animation = animation

      withTransaction(transaction) {
        job()
      }
    }
    
    await clock.trySleep(for: DelayDuration.frame)
  }
}

#endif
