//
//  InfoCoordinatorFactoryDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator
import SwiftUI

protocol InfoCoordinatorFactoryDelegateType: CoordinatorFactoryDelegateType {
  associatedtype FirstScreenType: View
  associatedtype LastScreenType: View
  
  func createFirstScreen(
    onContinue: @escaping () -> Void
  ) -> FirstScreenType
  
  func createLastScreen(
    onDone: @escaping () -> Void
  ) -> LastScreenType
}

struct InfoCoordinatorFactoryDelegate: InfoCoordinatorFactoryDelegateType {
  func createFirstScreen(
    onContinue: @escaping () -> Void
  ) -> some View {
    InfoFirstScreen(onContinue: onContinue)
  }
  
  func createLastScreen(
    onDone: @escaping () -> Void
  ) -> some View {
    InfoLastScreen(onDone: onDone)
  }
}
