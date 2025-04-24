//
//  TabContainer.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import Perception
import SwiftUI

#warning("TODO: Documentation")
public struct TabContainer<
  Coordinator: SpecimenCoordinatorType,
  Label: View
>: ObservingView {
  private let coordinator: Coordinator
  private let tabs: [Coordinator.SpecimenDestination]
  private let label: (Coordinator.SpecimenDestination) -> Label
  
  @Perception.Bindable
  private var state: SpecimenState

  public init(
    coordinator: Coordinator,
    tabs: [Coordinator.SpecimenDestination],
    @ViewBuilder label: @escaping (Coordinator.SpecimenDestination) -> Label
  ) {
    self.coordinator = coordinator
    self.tabs = tabs
    self.label = label
    self.state = coordinator.navigator._specimenState
  }
  
  public var content: some View {
    TabView(
      selection: $state.destination(for: Coordinator.SpecimenDestination.self)
    ) {
      ForEach(
        tabs,
        content: { [unowned coordinator] tab in
          coordinator.content(
            forSpecimen: tab
          )
          .tabItem {
            label(tab)
          }
          .tag(tab)
        }
      )
    }
    .optionalModal(for: coordinator)
    .optionalStackDestination(for: coordinator)
  }
}
