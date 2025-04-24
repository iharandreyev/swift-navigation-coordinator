//
//  StackCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

#warning("TODO: Documentation")
@MainActor
public protocol StackCoordinatorType: NavigationCoordinatorType where StackDestination: DestinationType { }

extension StackCoordinatorType {
  
  // MARK: Push
  
  public func push(
    _ destination: StackDestination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.push(
      destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func replaceLast(
    with destination: StackDestination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.replaceLast(
      with: destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func replacePath(
    with destination: StackDestination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.replacePath(
      with: destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  // MARK: Pop
  
  public func pop(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.pop(
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func popToDestination(
    _ destination: StackDestination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.popToDestination(
      destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func popToInitial(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.popToSomeDestination(
      id,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func popToRoot(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.popToRoot(
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
}
