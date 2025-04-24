//
//  SpecimenState+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(XCTest)

import Perception
import SwiftUI

extension SpecimenState {
  func testBinding<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self
  ) -> Binding<Destination> {
    Perception.Bindable(self).destination(for: destinationType)
  }
}

#endif
