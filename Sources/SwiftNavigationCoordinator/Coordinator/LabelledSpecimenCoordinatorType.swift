//
//  LabelledSpecimenCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol LabelledSpecimenCoordinatorType: SpecimenCoordinatorType {
  associatedtype LabelType: View
  
  @ViewBuilder
  func label(for tab: DestinationType) -> LabelType
}
