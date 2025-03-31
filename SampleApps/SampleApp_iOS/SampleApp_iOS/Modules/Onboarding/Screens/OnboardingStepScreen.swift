//
//  OnboardingStepScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct OnboardingStepScreen: View {
  let step: OnboardingStep
  let onNext: () -> Void
  let onShowInfo: () -> Void
  
  var body: some View {
    VStack(spacing: 32) {
      Text(
        """
          This is\n
          \(step.message)\n
          It shows a step of some flow with a button to present some info modally
        """
      )
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      Button(action: onNext) {
        Text(step.actionName)
      }
      
      Button(
        "Show info",
        action: onShowInfo
      )
    }
  }
}

#Preview {
  OnboardingStepScreen(
    step: OnboardingStep.allCases[0],
    onNext: {},
    onShowInfo: {}
  )
}
