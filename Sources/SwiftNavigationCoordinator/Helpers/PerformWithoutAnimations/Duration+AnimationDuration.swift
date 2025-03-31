//
//  Duration+AnimationDuration.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Foundation
import QuartzCore

extension Duration {
  @inline(__always)
  static func defaultAnimation() -> Self {
    .milliseconds(CATransaction.animationDurationMs())
  }
  
  static let frame: Self = .milliseconds(17)
}

private extension CATransaction {
  @inline(__always)
  static func animationDurationMs() -> UInt {
    UInt(animationDuration() * 1000)
  }
}
