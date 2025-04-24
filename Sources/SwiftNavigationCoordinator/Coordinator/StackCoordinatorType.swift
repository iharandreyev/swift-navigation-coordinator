//
//  StackCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol StackCoordinatorType: CoordinatorBase {
  associatedtype StackDestination: SomeDestination
  associatedtype StackDestinationScreen: View
  
  @ViewBuilder
  func content(
    forStack destination: StackDestination
  ) -> StackDestinationScreen
}

extension StackCoordinatorType {
  func screen(
    forStack destination: StackDestination
  ) -> some View {
    content(
      forStack: destination
    )
  }
}

extension StackCoordinatorType {
  
  // MARK: Push
  
  public func push(
    _ destination: StackDestination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.push(
      destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func replaceLast(
    with destination: StackDestination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.replaceLast(
      with: destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func replacePath(
    with destination: StackDestination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.replacePath(
      with: destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  // MARK: Pop
  
  public func pop(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.pop(
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func popToDestination(
    _ destination: StackDestination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.popToDestination(
      destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func popToRoot(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async where StackDestination: DestinationType {
    await navigator.popToRoot(
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
}
