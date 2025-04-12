//
//  StackNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

@MainActor
public final class StackNavigator<
  DestinationType: ScreenDestinationType
> {
  typealias DestinationType = DestinationType
  
  let state: StackState
  
  private let navigationQueue: NavigationQueue
  
  private(set)
  public var stack: [DestinationType] = []
  
  private(set)
  var parent: AnyStackNavigator?
  private(set)
  var child: AnyStackNavigator?
  
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
      navigationQueue: Environment.navigationQueue
    )
  }
  
  // MARK: - Push
  
  public func push(
    _ destination: DestinationType,
    animated: Bool = true,
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
      animated: animated
    )
  }
  
  @available(*, unavailable, message: "Not available until path items replacement issue is fixed")
  public func replaceLast(
    with destination: DestinationType,
    animated: Bool = true,
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
      animated: animated
    )
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(2)
        state.append(destination)
        
        self.stack.removeLast(2)
        self.stack.append(destination)
      },
      animated: false
    )
  }
  
  @available(*, unavailable, message: "Not available until path items replacement issue is fixed")
  public func replaceStack(
    with destination: DestinationType,
    animated: Bool = true,
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
      animated: animated
    )
    
    await navigationQueue.schedule(
      uiUpdate: { [weak self] in
        guard let self else { return }
        
        state.removeLast(state.count)
        state.append(destination)
        
        self.stack = [destination]
      },
      animated: false
    )
  }
  
  // MARK: - Pop
  
  public func pop(
    animated: Bool = true,
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
      animated: animated
    )
  }
  
  public func popToDestination(
    _ destination: DestinationType,
    animated: Bool = true,
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
      animated: animated
    )
  }
  
  public func popToRoot(
    animated: Bool = true,
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
        
        state.removeAll()
        stack = []
      },
      animated: animated
    )
    
    // Cleanup navigator hierarchy
    var bottomChild = self.eraseToAnyStackNavigator()
    while let child = bottomChild.child {
      bottomChild = child
    }
    
    while let parent = bottomChild.parent {
      bottomChild.stack = []
      bottomChild.child = nil
      bottomChild.parent = nil
      
      bottomChild = parent
    }

    let topParent = bottomChild
    
    topParent.stack = []
    topParent.child = nil
    topParent.parent = nil
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
    
    child.parent = self.eraseToAnyStackNavigator()
    self.child = child.eraseToAnyStackNavigator()
    
    return child
  }
  
  // MARK: - Validity
  
  private(set)
  var isValid: Bool = true
  
  private func invalidate() {
    let child = child
    let parent = parent
    
    isValid = false
    self.parent = nil
    self.child = nil
    
    parent?.child = nil
    child?.invalidate()
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

extension StackNavigator {
  func getParent(_ invocationPoint: String = #file) -> AnyStackNavigator? {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    return parent
  }
  
  func setParent(_ newValue: AnyStackNavigator?, _ invocationPoint: String = #file) {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    parent = newValue
  }
  
  func getChild(_ invocationPoint: String = #file) -> AnyStackNavigator? {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    return child
  }
  
  func setChild(_ newValue: AnyStackNavigator?, _ invocationPoint: String = #file) {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    child = newValue
  }
  
  func getStack(_ invocationPoint: String = #file) -> [AnyDestination] {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    return stack.map(AnyDestination.init)
  }
  
  func setStack(_ newValue: [AnyDestination], _ invocationPoint: String = #file) {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    if newValue.isEmpty {
      stack = []
    } else {
      stack = newValue.map {
        $0.wrapped as! DestinationType
      }
    }
  }
  
  func performInvalidate(_ invocationPoint: String = #file) {
    assert(invocationPoint.contains("AnyStackNavigator"))
    
    invalidate()
  }
}

#if canImport(XCTest)

extension StackNavigator {
  static func test(
    destinations: [DestinationType],
    navigationQueue: NavigationQueue = Environment.navigationQueue,
    isValid: Bool = true
  ) -> StackNavigator {
    Environment.assert(.test)
    
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
  
  func testInvalidate() {
    invalidate()
  }
}

#endif
