//
//  ModalState+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

import Perception
import SwiftUI

extension ModalState {
  func testBinding<Destination: Sendable & Hashable & Identifiable>(
    for destinationType: Destination.Type = Destination.self
  ) -> Binding<ModalDestinationPath<Destination>?> {
    Perception.Bindable(self).destination(for: destinationType)
  }
}

#endif
