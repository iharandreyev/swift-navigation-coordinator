//
//  CoordinatedScreen+TabView.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Perception
import SwiftUI
import SUIOnRemoveFromParent

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator` and is intended to present `TabView`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build tab view` requrests to the coordinator;
  /// * pass `build tab label` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  public static func tabbed<
    CoordinatorType: LabelledSpecimenCoordinatorType
  >(
    coordinator: CoordinatorType
  ) -> some View where CoordinatorType.DestinationType: CaseIterable, CoordinatorType.DestinationType.AllCases: RandomAccessCollection {
    CoordinatedScreen_Tabbed(coordinator: coordinator)
  }
  
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator` and is intended to present `TabView`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build tab view` requrests to the coordinator;
  /// * pass `build tab label` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  /// * send `coordinator.finish` when the view is removed from view hierarchy;
  static func tabbed<
    CoordinatorType: LabelledSpecimenCoordinatorType
  >(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.DestinationType]
  ) -> some View {
    CoordinatedScreen_Tabbed(coordinator: coordinator, tabs: tabs)
  }
}

import Perception
import SUIOnRemoveFromParent

struct CoordinatedScreen_Tabbed<
  CoordinatorType: LabelledSpecimenCoordinatorType
>: ObservingView {
  private let coordinator: CoordinatorType
  @Perception.Bindable
  private var state: SpecimenState
  
  private let tabs: [CoordinatorType.DestinationType]

  init(
    coordinator: CoordinatorType
  ) where CoordinatorType.DestinationType: CaseIterable, CoordinatorType.DestinationType.AllCases: RandomAccessCollection {
    self.coordinator = coordinator
    self.state = coordinator.specimenNavigator.state
    self.tabs = Array(CoordinatorType.DestinationType.allCases)
  }
  
  init(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.DestinationType]
  ) {
    self.coordinator = coordinator
    self.state = coordinator.specimenNavigator.state
    self.tabs = tabs
  }
  
  var content: some View {
    TabView(
      selection: $state.destinationOf(CoordinatorType.DestinationType.self)
    ) {
      ForEach(
        tabs,
        id: \.self,
        content: { [unowned coordinator] tab in
          coordinator.screen(
            for: tab
          )
          .tabItem {
            coordinator.label(for: tab)
          }
          .tag(tab)
        }
      )
    }
    .onRemoveFromParent(
      perform: { [weak coordinator] in
        coordinator?.finish()
      }
    )
    .animation(
      .easeInOut,
      value: state._destination
    )
  }
}
