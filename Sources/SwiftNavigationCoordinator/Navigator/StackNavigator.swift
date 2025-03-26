//
//  StackNavigator.swift
//  SwiftNavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

@MainActor
public protocol StackNavigatorType<DestinationType> {
  associatedtype DestinationType: ScreenDestinationType
  
  var state: StackState { get }
  
  func push(_ destination: DestinationType)
  
  func replaceLast(with destination: DestinationType)
  func replaceStack(with destination: DestinationType)
  
  func pop()
  func popToRoot()
  
  func scope<
    ChildDestinationType: ScreenDestinationType
  >() -> any StackNavigatorType<ChildDestinationType>
}

@MainActor
public final class StackNavigator<
  DestinationType: ScreenDestinationType
>: StackNavigatorType {
  public let state: StackState

  public init(
    state: StackState = StackState()
  ) {
    self.state = state
  }
  
  public func push(_ destination: DestinationType) {
    state.append(destination)
  }
  
  public func replaceLast(with destination: DestinationType) {
    push(destination)
    
    withoutAnimations { [weak self] in
      self?.pop()
      self?.push(destination)
    }
  }
  
  public func replaceStack(with destination: DestinationType) {
    push(destination)
    
    withoutAnimations { [weak self] in
      self?.popToRoot()
      self?.push(destination)
    }
  }
  
  public func pop() {
    state.removeLast()
  }
  
  public func popToRoot() {
    state.removeLast(state.count)
  }
  
  public func scope<
    ChildDestinationType: ScreenDestinationType
  >() -> any StackNavigatorType<ChildDestinationType> {
    StackNavigator<ChildDestinationType>(
      state: state
    )
  }
}
