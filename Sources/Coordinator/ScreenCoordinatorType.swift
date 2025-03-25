//
//  ScreenCoordinatorType.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI
import SUIOnRemoveFromParent

/// Base coordinator protocol that should be implemented by every coordinator that does not manage the application root
@MainActor
public protocol ScreenCoordinatorType: CoordinatorBase {
  associatedtype InitialScreenContentType: View
  
  @ViewBuilder
  func initialScreenContent() -> InitialScreenContentType
}

extension ScreenCoordinatorType {
  public func initialScreen() -> some View {
    initialScreenContent()
      .onRemoveFromParent{ [weak self] in
        self?.finish()
      }
  }
}
