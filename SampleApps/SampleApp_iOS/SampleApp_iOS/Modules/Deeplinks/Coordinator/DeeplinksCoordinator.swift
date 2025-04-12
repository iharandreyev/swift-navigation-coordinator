//
//  DeeplinksCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

final class DeeplinksCoordinator: CoordinatorBase, ScreenCoordinatorType {
  func initialScreen() -> some View {
    DeeplinksListScreen()
  }
}
