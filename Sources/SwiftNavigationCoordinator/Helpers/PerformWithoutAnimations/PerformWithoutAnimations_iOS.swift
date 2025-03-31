//
//  PerformWithoutAnimations.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

#if os(iOS)

import Foundation
import SwiftUI
import UIKit

@MainActor
func withoutAnimations_iOS(
  perform job: @MainActor @escaping () -> Void
) {
  if #available(iOS 18, *) {
    withoutAnimations_new(perform: job)
  } else {
    withoutAnimations_old(perform: job)
  }
}

@available(iOS, deprecated: 18, message: "Use Transaction-based solution for iOS 18+")
@MainActor
private func withoutAnimations_old(
  perform job: @MainActor @escaping () -> Void
) {
  // Delays are doubled, since any lesser values yilded StackPath glitches
  Task {
    UIDisable.setUiDisabled(true)
    try await Task.sleep(for: .defaultAnimation() * 2)
    UIView.setAnimationsEnabled(false)
    try await Task.sleep(for: .frame * 2)
    job()
    try await Task.sleep(for: .frame * 2)
    UIView.setAnimationsEnabled(true)
    UIDisable.setUiDisabled(false)
  }
}

@available(iOS 18, *)
@MainActor
private func withoutAnimations_new(
  perform job: @MainActor @escaping () -> Void
) {
  var noAnimationTransaction = Transaction()
  noAnimationTransaction.disablesAnimations = true

  Task {
    try await Task.sleep(for: .defaultAnimation())
    try withTransaction(noAnimationTransaction, job)
  }
}

#endif
