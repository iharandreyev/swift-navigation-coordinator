//
//  WithAnimations.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import Clocks
import SwiftUI

actor WithAnimations {
  let clock: AnyClock<Duration>

  init<ClockType: Clock<Duration>>(clock: ClockType) {
    self.clock = AnyClock(clock)
  }

  @MainActor
  func run(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    withAnimation(.default) {
      job()
    }
    
    await clock.trySleep(for: DelayDuration.transitionAnimation)
  }
}
