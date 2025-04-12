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
    onContinue: Callback<Void>
  ) -> FirstScreenType
  
  func createLastScreen(
    onDone: Callback<Void>
  ) -> LastScreenType
}

struct InfoCoordinatorFactoryDelegate: InfoCoordinatorFactoryDelegateType {
  func createFirstScreen(
    onContinue: Callback<Void>
  ) -> some View {
    InfoFirstScreen(onContinue: onContinue.callAsFunction)
  }
  
  func createLastScreen(
    onDone: Callback<Void>
  ) -> some View {
    InfoLastScreen(onDone: onDone.callAsFunction)
  }
}
