//
//  GlobalUIState.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception

@MainActor
@Perceptible
final class GlobalUIState {
  var isDisabled = false
  
  fileprivate init() { }
  
  static let shared = GlobalUIState()
}
