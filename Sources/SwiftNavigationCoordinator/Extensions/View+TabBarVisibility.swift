//
//  View+TabBarVisibility.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

private struct SetTabBarVisibilityOnAppearViewModifier: ViewModifier {
  @State
  private var currentVisibility: Visibility = .automatic
  
  private let requiredVisibility: Visibility
  
  init(requiredVisibility: Visibility) {
    self.requiredVisibility = requiredVisibility
  }
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        currentVisibility = requiredVisibility
      }
      .toolbar(currentVisibility, for: .tabBar)
      .animation(.easeInOut, value: currentVisibility)
  }
}

extension View {
  @inline(__always)
  public func setTabBarVisibilityOnAppear(
    _ visibility: Visibility
  ) -> some View {
    modifier(
      SetTabBarVisibilityOnAppearViewModifier(
        requiredVisibility: visibility
      )
    )
  }
  
  @inline(__always)
  public func setTabBarVisibleOnAppear() -> some View {
    self
      .setTabBarVisibilityOnAppear(.visible)
  }
  
  @inline(__always)
  public func setTabBarHiddenOnAppear() -> some View {
    self
      .ignoresSafeArea(.container, edges: .bottom)
      .setTabBarVisibilityOnAppear(.hidden)
  }
}
