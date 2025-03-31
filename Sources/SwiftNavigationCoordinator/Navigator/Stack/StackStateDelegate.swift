//
//  StackStateDelegate.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

enum StackUserInteraction {
  case pop
  case popToRoot
}

@MainActor
protocol StackStateDelegate: AnyObject {
  func userDidChangeStack(with interaction: StackUserInteraction)
}
