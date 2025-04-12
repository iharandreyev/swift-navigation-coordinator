//
//  StackNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public final class StackNavigator<
  DestinationType: ScreenDestinationType
>: AnyStackNavigator {
  let state: StackState
  
  private let navigationQueue: NavigationQueue
  
  private(set)
  public var stack: [DestinationType] = []
  
  // This property is used only for scoping, which is infrequent, so existential container is OK
  fileprivate
  weak var parent: (any AnyStackNavigator)?
  
  // MARK: - Init
  
  private init(
    state: StackState,
    navigationQueue: NavigationQueue
  ) {
    self.state = state
    self.navigationQueue = navigationQueue
    
    state.delegate = self
  }
  
  public convenience init() {
    self.init(
      state: StackState(),
      navigationQueue: .shared
    )
  }
  
  // MARK: - Push
  
  public func push(
    _ destination: DestinationType,
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "push(\(ShortDescription(destination)))",
      file: file,
      line: line
    ) else {
      return
    }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.append(destination)
        stack.append(destination)
      },
      animation: animation
    )
  }
  
  public func replaceLast(
    with destination: DestinationType,
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "replaceLast(\(ShortDescription(destination)))",
      file: file,
      line: line
    ) else {
      return
    }
    
    guard !state.isEmpty else {
      return logWarning(
        """
          Can't replace last with `\(ShortDescription(destination))` since the stack is empty. \
          Ignoring `replaceLast`.
        """,
        file: file,
        line: line
      )
    }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.append(destination)
        stack.append(destination)
      },
      animation: animation
    )
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(2)
        state.append(destination)
        
        self.stack.removeLast(2)
        self.stack.append(destination)
      },
      animation: nil
    )
  }
  
  public func replaceStack(
    with destination: DestinationType,
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "replaceStack(with: \(ShortDescription(destination)))",
      file: file,
      line: line
    ) else {
      return
    }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.append(destination)
        stack.append(destination)
      },
      animation: animation
    )
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(state.count)
        state.append(destination)
        
        self.stack = [destination]
      },
      animation: nil
    )
  }
  
  // MARK: - Pop
  
  public func pop(
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "pop",
      file: file,
      line: line
    ) else {
      return
    }
    
    guard !state.isEmpty else {
      return logWarning(
        """
          Can't pop since the stack is empty. \
          Ignoring `pop`.
        """
      )
    }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast()
        stack.removeLast()
      },
      animation: animation
    )
  }
  
  public func popToDestination(
    _ destination: DestinationType,
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "popToDestination(\(ShortDescription(destination)))",
      file: file,
      line: line
    ) else {
      return
    }
    
    guard let index = stack.firstIndex(of: destination) else {
      return logWarning(
        """
          Destination `\(ShortDescription(destination))` is not present in the stack. \
          Ignoring `popToDestination`.
        """,
        file: file,
        line: line
      )
    }
    
    let itemsToRemove = stack.count - index - 1
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(itemsToRemove)
        stack.removeLast(itemsToRemove)
      },
      animation: animation
    )
  }
  
  public func popToRoot(
    animation: Animation? = .default,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    guard canPerformOperation(
      "popToRoot",
      file: file,
      line: line
    ) else {
      return
    }
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(stack.count)
        stack = []
      },
      animation: animation
    )
  }
  
  // MARK: - Scope
  
  public func scope<
    ChildDestinationType: ScreenDestinationType
  >(
    file: StaticString = #file,
    line: UInt = #line
  ) -> StackNavigator<ChildDestinationType> {
    guard canPerformOperation(
      "scope",
      file: file,
      line: line
    ) else {
      fatalError(file: file, line: line)
    }
    
    let child = StackNavigator<ChildDestinationType>(
      state: state,
      navigationQueue: navigationQueue
    )
    child.parent = self
    return child
  }
  
  // MARK: - Validity
  
  private(set)
  var isValid: Bool = true
  
  private func invalidate() {
    isValid = false
    parent = nil
  }
  
  @inline(__always)
  private func canPerformOperation(
    _ operation: @autoclosure @escaping () -> String,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Bool {
    guard isValid else {
      logWarning(
        """
          Can't perform `\(operation())`.                             \
          Reason: `\(ShortDescription(self))` has been invalidated.   
        """,
        file: file,
        line: line
      )
      
      return false
    }
    
    return true
  }
}

extension StackNavigator: StackStateDelegate {
  func userDidChangeStack(
    with interaction: StackUserInteraction
  ) {
    guard isValid else { return }
    
    switch interaction {
    case .popToRoot:
      stack = []
    case .pop where stack.isEmpty:
      // SUI has popped a destination this navigation is scoped for
      userDidPopRoot(with: interaction)
    case .pop:
      stack.removeLast()
    }
  }
  
  private func userDidPopRoot(with interaction: StackUserInteraction) {
    defer {
      invalidate()
    }
    
    guard let parent else {
      return logWarning(
        """
          Can't pop stack of `\(ShortDescription(self))`, 
          since it's already empty, and parent is not set
        """
      )
    }
    
    parent.state.delegate = parent
    parent.userDidChangeStack(with: interaction)
  }
}

private protocol AnyStackNavigator: AnyObject, StackStateDelegate {
  var state: StackState { get }
}

#if canImport(XCTest)

extension StackNavigator {
  static func test(
    destinations: [DestinationType],
    navigationQueue: NavigationQueue = .test(),
    isValid: Bool = true
  ) -> StackNavigator {
    let state = StackState()
    let navigator = StackNavigator(state: state, navigationQueue: navigationQueue)
    
    destinations.forEach {
      state.append($0)
    }
    
    navigator.stack = destinations
    
    guard !isValid else { return navigator }
    
    navigator.invalidate()
    return navigator
  }
}

#endif
