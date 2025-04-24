//
//  AppContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

#warning("TODO: Documentation")
/// Use this at the app entry point to ensure all operations without animation work properly
public struct AppContainer<Content: View>: View {
  private let content: () -> Content
  
  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
  }
  
  public var body: some View {
    content().disableUiWhenAnimationsAreDisabled()
  }
}
