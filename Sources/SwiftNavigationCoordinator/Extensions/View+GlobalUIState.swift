//
//  View+GlobalUIState.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI

private struct WithGlobalUIStateViewModifier: ViewModifier {
  private let uiState = GlobalUIState.shared
  
  func body(content: Content) -> some View {
    WithPerceptionTracking {
      content.disabled(uiState.isDisabled)
    }
  }
}

extension View {
  @inline(__always)
  public func withGlobalUIState() -> some View {
    modifier(WithGlobalUIStateViewModifier())
  }
}
