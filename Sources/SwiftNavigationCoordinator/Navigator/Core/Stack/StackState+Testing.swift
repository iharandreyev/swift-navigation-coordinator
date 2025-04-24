//
//  StackState+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

import Perception
import SwiftUI

extension StackState {
  func testBinding() -> Binding<SwiftUI.NavigationPath> {
    Perception.Bindable(self).path()
  }
}

#endif
