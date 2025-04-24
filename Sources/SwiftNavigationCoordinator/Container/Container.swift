//
//  Container.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

public struct Container<
  Coordinator: NavigationCoordinatorType,
  Content: View
>: View {
  private let coordinator: Coordinator
  private let content: () -> Content
  
  public init(
    coordinator: Coordinator,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.coordinator = coordinator
    self.content = content
  }
  
  public var body: some View {
    content()
      .optionalModal(for: coordinator)
      .optionalStackDestination(for: coordinator)
  }
}
