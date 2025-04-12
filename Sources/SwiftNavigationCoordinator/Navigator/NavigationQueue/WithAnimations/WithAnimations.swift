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
  
#if os(iOS)
  private lazy var wrapped = WithAnimations_iOS(clock: clock)
#else
  private lazy var wrapped = WithAnimations_unsupported(clock: clock)
#endif
  
  init<ClockType: Clock<Duration>>(clock: ClockType) {
    self.clock = AnyClock(clock)
  }

  func run(
    _ job: @MainActor @Sendable @escaping () -> Void,
    animation: Animation
  ) async {
    await wrapped.run(job, animation: animation)
  }
}
