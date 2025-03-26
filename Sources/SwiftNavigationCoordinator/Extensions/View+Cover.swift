//
//  View+Cover.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
extension View {
  #if os(iOS)
  
  @inline(__always)
  @ViewBuilder
  func cover<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    fullScreenCover(
      item: item,
      onDismiss: onDismiss,
      content: content
    )
  }
  
  #endif
}
