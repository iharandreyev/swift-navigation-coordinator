//
//  StackNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
#warning("TODO: Implement async methods to 1. wait for animation complete; 2. test methods that disable animations")
@available(iOS 16, *)
@MainActor
public final class StackNavigator<
  DestinationType: ScreenDestinationType
>: AnyStackNavigator {
  let state: StackState

  private(set)
  public var stack: [DestinationType] = []
  
  // This property is used only for scoping, which is infrequent, so existential container is OK
  fileprivate
  weak var parent: (any AnyStackNavigator)?
  
  // MARK: - Init
  
  private init(
    state: StackState
  ) {
    self.state = state
    state.delegate = self
  }
  
  public convenience init() {
    self.init(state: StackState())
  }
  
  // MARK: - Push
  
  public func push(
    _ destination: DestinationType,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }
    
    state.append(destination)
    stack.append(destination)
  }
  
  public func replaceLast(
    with destination: DestinationType,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }
    
    guard !state.isEmpty else {
      return logWarning(
        """
          Can't replace last with `\(ShortDescription(destination))` since the stack is empty. \
          Ignoring `replaceLast`.
        """
      )
    }

    state.append(destination)
    
    withoutAnimations { [weak self, weak state] in
      guard let self, let state else { return }
      
      state.removeLast(2)
      state.append(destination)
      
      self.stack.removeLast()
      self.stack.append(destination)
    }
  }
  
  public func replaceStack(
    with destination: DestinationType,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }

    push(destination)
    
    withoutAnimations { [weak self, weak state] in
      guard let self, let state else { return }
      
      state.removeLast(state.count)
      state.append(destination)
      
      self.stack = [destination]
    }
  }
  
  // MARK: - Pop
  
  public func pop(
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }
    
    guard !state.isEmpty else {
      return logWarning(
        """
          Can't pop since the stack is empty. \
          Ignoring `pop`.
        """
      )
    }
    
    state.removeLast()
    stack.removeLast()
  }
  
  public func popToDestination(
    _ destination: DestinationType,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }
    
    guard let index = stack.firstIndex(of: destination) else {
      return logWarning(
        """
          Destination `\(ShortDescription(destination))` is not present in the stack. \
          Ignoring `popToDestination`.
        """
      )
    }
    
    let itemsToRemove = stack.count - index - 1
    
    state.removeLast(itemsToRemove)
    stack.removeLast(itemsToRemove)
  }
  
  public func popToRoot(
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard canPerformOperation(file: file, line: line) else { return }
    
    state.removeLast(stack.count)
    stack = []
  }
  
  // MARK: - Scope
  
  public func scope<
    ChildDestinationType: ScreenDestinationType
  >(
    file: StaticString = #file,
    line: UInt = #line
  ) -> StackNavigator<ChildDestinationType> {
    guard canPerformOperation(file: file, line: line) else {
      fatalError(
        "Can't scope from invalidated navigator",
        file: file,
        line: line
      )
    }
    
    let child = StackNavigator<ChildDestinationType>(
      state: state
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
    file: StaticString = #file,
    line: UInt = #line
  ) -> Bool {
    guard isValid else {
      logWarning(
        "`\(ShortDescription(self))` has been invalidated. All operations will be ignored"
      )
      
      return false
    }
    
    #warning("TODO: Cover with tests and remove")
    assert(state.count == stack.count)
    
    return true
  }
}

extension StackNavigator: StackStateDelegate {
  func userDidChangeStack(
    with interaction: StackUserInteraction
  ) {
    guard canPerformOperation() else { return }

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
        "Can't pop stack of `\(self)`, since it's already empty, and parent is not set"
      )
    }
    
    parent.state.delegate = parent
    parent.userDidChangeStack(with: interaction)
  }
}

private protocol AnyStackNavigator: AnyObject, StackStateDelegate {
  var state: StackState { get }
}
