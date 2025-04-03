//
//  WithoutAnimations.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import Clocks

actor WithoutAnimations {
  let clock: AnyClock<Duration>
  
#if os(iOS)
  private lazy var wrapped = WithoutAnimations_iOS(clock: clock)
#else
  private lazy var wrapped = WithoutAnimations_unsupported(clock: clock)
#endif
  
  init<ClockType: Clock<Duration>>(clock: ClockType) {
    self.clock = AnyClock(clock)
  }
  
  func run(
    _ job: @Sendable @escaping () -> Void
  ) async  {
    await wrapped.run(job)
  }
}
