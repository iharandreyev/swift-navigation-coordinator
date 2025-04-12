//
//  WithAnimations+unsupported.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if !os(iOS)

import Clocks

actor WithAnimations_unsupported {
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
    fatalError("Current platform is not yet supported!")
  }
}

#endif
