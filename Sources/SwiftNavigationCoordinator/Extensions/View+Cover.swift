//
//  View+Cover.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension View {
  @inline(__always)
  public func cover<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    #if os(macOS)
      return sheet(
        item: item,
        onDismiss: onDismiss,
        content: content
      )
    #else
      return fullScreenCover(
        item: item,
        onDismiss: onDismiss,
        content: content
      )
    #endif
  }
}
