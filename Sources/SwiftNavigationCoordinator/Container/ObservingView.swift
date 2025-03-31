//
//  ObservingView.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI
import Perception

@available(
  iOS, deprecated: 17, message: "'ObservingView' is no longer needed in iOS 17+"
)
@available(
  macOS, deprecated: 14, message: "'ObservingView' is no longer needed in macOS 14+"
)
@available(
  watchOS, deprecated: 10, message: "'ObservingView' is no longer needed in watchOS 10+"
)
@available(
  tvOS, deprecated: 17, message: "'ObservingView' is no longer needed in tvOS 17+"
)
public protocol ObservingView<Content>: View where Body == WithPerceptionTracking<Content> {
  associatedtype Content: View
  
  var content: Content { get }
}

extension ObservingView {
  public var body: Body {
    WithPerceptionTracking {
      content
    }
  }
}
