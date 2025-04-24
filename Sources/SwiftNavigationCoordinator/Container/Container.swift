//
//  Container.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import SwiftUI

#warning("TODO: Documentation")
/*
 A root container for any coordinator that is not in the root of the current navigation flow.
 
 Subscribes to coordinator modal and stack presentation if necessary.
 */
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
