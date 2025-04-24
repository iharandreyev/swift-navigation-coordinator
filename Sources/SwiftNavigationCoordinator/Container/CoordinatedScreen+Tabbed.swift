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
  ) -> some View where CoordinatorType.Destination: CaseIterable, CoordinatorType.Destination.AllCases: RandomAccessCollection {
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
    tabs: [CoordinatorType.Destination]
  ) -> some View {
    _CoordinatedScreen_Tabbed(coordinator: coordinator, tabs: tabs)
  }
}

struct _CoordinatedScreen_Tabbed<
  CoordinatorType: LabelledSpecimenCoordinatorType
>: View {
  private let coordinator: CoordinatorType
  private let navigator: Navigator
  
  private let tabs: [CoordinatorType.Destination]
  
  init(
    coordinator: CoordinatorType
  ) where CoordinatorType.Destination: CaseIterable, CoordinatorType.Destination.AllCases: RandomAccessCollection {
    self.init(
      coordinator: coordinator,
      tabs: Array(CoordinatorType.Destination.allCases)
    )
  }
  
  init(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.Destination]
  ) {
    self.coordinator = coordinator
    self.navigator = coordinator.navigator
    self.tabs = tabs
  }
  
  var body: some View {
    SpecimenContainer(
      navigator: navigator,
      destinationContent: { (destination: Binding<CoordinatorType.Destination>) in
        TabView(
          selection: destination
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
      }
    )
  }
}
