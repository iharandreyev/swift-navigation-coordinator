//
//  DelayDuration.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import QuartzCore

import UIKit

enum DelayDuration {
  static var transitionAnimation: Duration {
    let defaultValue = CATransaction.getAnimationDuration()
    // SUI attempts to glue animations together, which results in an ugly behavior on iOS 18, and erros on iOS 17-
    // Doubling default duration value has proven to be sufficient.
    // The doubled value is still small enough for users to notice
    return defaultValue * 2
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
