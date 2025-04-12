//
//  DelayDuration.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import QuartzCore

enum DelayDuration {
  static var transitionAnimation: Duration {
    .milliseconds(CATransaction.transitionAnimationDurationMs)
  }
  
  static let frame: Duration = {
    let defaultValue = Duration.milliseconds(17)
    
    if #available(iOS 18, *) {
      return defaultValue
    } else {
      // iOS 17 and below don't work properly with the default value.
      // Extra delay is needed.
      // Experiments have shown that for these older plafrorms the delay should be x2
      // Any lesser values yilded StackPath glitches
      return defaultValue * 2
    }
  }()
}

private extension CATransaction {
  @inline(__always)
  static var transitionAnimationDurationMs: UInt {
    let defaultValue = UInt(animationDuration() * 1000)
    
    if #available(iOS 18, *) {
      return defaultValue
    } else {
      // iOS 17 and below don't work properly with the default value.
      // Extra delay is needed.
      // Experiments have shown that for these older plafrorms the delay should be x2
      // Any lesser values yilded StackPath glitches
      return defaultValue * 2
    }
  }
}
