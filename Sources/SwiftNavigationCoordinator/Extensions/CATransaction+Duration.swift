//
//  CATransaction+Duration.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import QuartzCore

extension CATransaction {
  @inline(__always)
  static func getAnimationDuration() -> Duration {
    .milliseconds(UInt(animationDuration() * 1000))
  }
}
