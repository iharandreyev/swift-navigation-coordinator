//
//  OnboardingStep.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

struct OnboardingStep: Hashable, Identifiable {
  let id: String
  let message: String
  let actionName: String
  
  private init(
    id: String,
    message: String,
    actionName: String = "Next"
  ) {
    self.id = id
    self.message = message
    self.actionName = actionName
  }
}

extension OnboardingStep: CaseIterable {
  static var allCases: [Self] {
    return [
      OnboardingStep(
        id: "0",
        message: "First onboarding step"
      ),
      OnboardingStep(
        id: "1",
        message: "Second onboarding step"
      ),
      OnboardingStep(
        id: "2",
        message: "Third onboarding step"
      ),
      OnboardingStep(
        id: "3",
        message: "Last onboarding step",
        actionName: "Finish"
      )
    ]
  }
}

extension OnboardingStep: CustomStringConvertible {
  var description: String {
    return "OnboardingStep(id: \(id)"
  }
}
