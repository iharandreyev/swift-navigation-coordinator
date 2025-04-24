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
    CoordinatorType: LabelledSpecimenCoordinatorType
  >(
    coordinator: CoordinatorType
  ) -> some View where CoordinatorType.SpecimenDestination: DestinationType, CoordinatorType.SpecimenDestination: CaseIterable, CoordinatorType.SpecimenDestination.AllCases: RandomAccessCollection {
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
    CoordinatorType: LabelledSpecimenCoordinatorType
  >(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.SpecimenDestination]
  ) -> some View where CoordinatorType.SpecimenDestination: DestinationType {
    _CoordinatedScreen_Tabbed(coordinator: coordinator, tabs: tabs)
  }
}

struct _CoordinatedScreen_Tabbed<
  CoordinatorType: LabelledSpecimenCoordinatorType
>: View where CoordinatorType.SpecimenDestination: DestinationType {
  private let coordinator: CoordinatorType
  private let navigator: Navigator
  
  private let tabs: [CoordinatorType.SpecimenDestination]
  
  init(
    coordinator: CoordinatorType
  ) where CoordinatorType.SpecimenDestination: CaseIterable, CoordinatorType.SpecimenDestination.AllCases: RandomAccessCollection {
    self.init(
      coordinator: coordinator,
      tabs: Array(CoordinatorType.SpecimenDestination.allCases)
    )
  }
  
  init(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.SpecimenDestination]
  ) {
    self.coordinator = coordinator
    self.navigator = coordinator.navigator
    self.tabs = tabs
  }
  
  var body: some View {
    SpecimenContainer(
      navigator: navigator,
      destinationContent: { (destination: Binding<CoordinatorType.SpecimenDestination>) in
        TabView(
          selection: destination
        ) {
          ForEach(
            tabs,
            id: \.self,
            content: { [unowned coordinator] tab in
              coordinator.screen(
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
