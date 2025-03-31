//
//  UIDisable.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

@MainActor
@Perceptible
final class UIDisable {
  fileprivate var isDisabled = false
  
  private init() { }
  
  fileprivate static let shared = UIDisable()
}

extension UIDisable {
  static func setUiDisabled(_ isDisabled: Bool) {
    UIDisable.shared.isDisabled = isDisabled
  }
}

private struct UIDisableViewModifier: ViewModifier {
  private let state = UIDisable.shared
  
  func body(content: Content) -> some View {
    WithPerceptionTracking {
      content.disabled(state.isDisabled)
    }
  }
}

extension View {
  @inline(__always)
  public func disableUiWhenAnimationsAreDisabled() -> some View {
    modifier(UIDisableViewModifier())
  }
}
