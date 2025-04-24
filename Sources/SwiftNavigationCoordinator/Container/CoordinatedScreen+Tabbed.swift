//
//  CoordinatedScreen+TabView.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension CoordinatedScreen {
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator` and is intended to present `TabView`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build tab view` requrests to the coordinator;
  /// * pass `build tab label` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  public static func tabbed<
    Coordinator: LabelledSpecimenCoordinatorType
  >(
    coordinator: Coordinator
  ) -> some View where Coordinator.SpecimenDestination: CaseIterable, Coordinator.SpecimenDestination.AllCases: RandomAccessCollection {
    _CoordinatedScreen_Tabbed(coordinator: coordinator)
  }
  
  /// Creates a container view that interfaces with a specimen coordinator.
  /// Use this factory method for cases when the managing coordinator interfaces `SpecimenNavigator` and is intended to present `TabView`.
  ///
  /// The view configures infrastructure to:
  /// * pass `build tab view` requrests to the coordinator;
  /// * pass `build tab label` requrests to the coordinator;
  /// * observe destinations to be presented using coordinator's `SpecimenNavigator`;
  public static func tabbed<
    Coordinator: LabelledSpecimenCoordinatorType
  >(
    coordinator: Coordinator,
    tabs: [Coordinator.SpecimenDestination]
  ) -> some View {
    _CoordinatedScreen_Tabbed(coordinator: coordinator, tabs: tabs)
  }
}

struct _CoordinatedScreen_Tabbed<
  Coordinator: LabelledSpecimenCoordinatorType
>: View {
  private let coordinator: Coordinator
  private let navigator: Navigator
  
  private let tabs: [Coordinator.SpecimenDestination]
  
  init(
    coordinator: Coordinator
  ) where Coordinator.SpecimenDestination: CaseIterable, Coordinator.SpecimenDestination.AllCases: RandomAccessCollection {
    self.init(
      coordinator: coordinator,
      tabs: Array(Coordinator.SpecimenDestination.allCases)
    )
  }
  
  init(
    coordinator: Coordinator,
    tabs: [Coordinator.SpecimenDestination]
  ) {
    self.coordinator = coordinator
    self.navigator = coordinator.navigator
    self.tabs = tabs
  }
  
  var body: some View {
    SpecimenContainer(
      navigator: navigator,
      destinationContent: { (destination: Binding<Coordinator.SpecimenDestination>) in
        TabView(
          selection: destination
        ) {
          ForEach(
            tabs,
            id: \.self,
            content: { [unowned coordinator] tab in
              coordinator.content(
                forSpecimen: tab
              )
              .tabItem {
                coordinator.label(forSpecimen: tab)
              }
              .tag(tab)
            }
          )
        }
      }
    )
  }
}
