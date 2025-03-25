//
//  AppRoot.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

public struct AppRoot<
  CoordinatorType: SpecimenCoordinatorType
>: View {
  private let coordinator: CoordinatorType
  
  public init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
  
  public var body: some View {
    CoordinatedScreen.specimen(
      coordinator: coordinator
    )
    .withGlobalUIState()
  }
}
