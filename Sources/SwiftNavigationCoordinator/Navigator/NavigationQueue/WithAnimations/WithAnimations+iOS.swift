//
//  WithAnimations+iOS.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if os(iOS)

import SwiftUI
import UIKit

actor WithAnimations_iOS {
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
    await withCheckedContinuation { continuation in
      CATransaction.begin()
      CATransaction.setCompletionBlock {
        continuation.resume()
      }
      job()
      CATransaction.commit()
    }
  }
  
  @available(iOS 18, *)
  @MainActor
  private func run_new(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    await withCheckedContinuation { continuation in
      var transaction = Transaction()
      transaction.addAnimationCompletion {
        continuation.resume()
      }
      
      withTransaction(transaction) {
        job()
      }
    }
  }
}

#endif
