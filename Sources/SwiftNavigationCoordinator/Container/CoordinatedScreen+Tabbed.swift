//
//  CoordinatedScreen+TabView.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
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
    _CoordinatedScreen_Tabbed(coordinator: coordinator)
  }
  
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
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.DestinationType]
  ) -> some View {
    _CoordinatedScreen_Tabbed(coordinator: coordinator, tabs: tabs)
  }
}

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@available(iOS 16, *)
struct _CoordinatedScreen_Tabbed<
  CoordinatorType: LabelledSpecimenCoordinatorType
>: View {
  private let coordinator: CoordinatorType
  private let specimenNavigator: SpecimenNavigator<CoordinatorType.DestinationType>
  
  private let tabs: [CoordinatorType.DestinationType]
  
  init(
    coordinator: CoordinatorType
  ) where CoordinatorType.DestinationType: CaseIterable, CoordinatorType.DestinationType.AllCases: RandomAccessCollection {
    self.init(
      coordinator: coordinator,
      tabs: Array(CoordinatorType.DestinationType.allCases)
    )
  }
  
  init(
    coordinator: CoordinatorType,
    tabs: [CoordinatorType.DestinationType]
  ) {
    self.coordinator = coordinator
    self.specimenNavigator = coordinator.specimenNavigator
    self.tabs = tabs
  }
  
  var body: some View {
    SpecimenContainer(
      specimenNavigator: specimenNavigator,
      destinationContent: { destination in
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
    .animation(
      .easeInOut,
      value: specimenNavigator.destination
    )
  }
}
