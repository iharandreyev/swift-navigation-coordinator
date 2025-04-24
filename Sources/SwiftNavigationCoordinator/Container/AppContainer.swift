//
//  AppContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

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
