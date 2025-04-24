//
//  Navigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
public final class Navigator {
  private let createSpecimenState: () -> SpecimenState
  private let createModalState: () -> ModalState
  private let createStackState: () -> StackState
  
  private let navigationQueue: AnyNavigationQueue
  
  // States are initialized lazily to avoid unnecessary init when appropriate states are not used by a coordinator
  private(set) lazy var _specimenState: SpecimenState = createSpecimenState()
  
  private(set) lazy var _modalState: ModalState = {
    let state = createModalState()
    state.appendDelegate(self)
    return state
  }()
  
  private(set) lazy var _stackState: StackState = {
    let state = createStackState()
    state.appendDelegate(self)
    return state
  }()
  
  weak var delegate: NavigatorDelegate?
  
  // MARK: - Init

  fileprivate init<NavigationQueue: NavigationQueueType>(
    createSpecimenState: @MainActor @Sendable @escaping () -> SpecimenState = { SpecimenState() },
    createModalState: @MainActor @Sendable @escaping () -> ModalState = { ModalState() },
    createStackState: @MainActor @Sendable @escaping () -> StackState = { StackState() },
    navigationQueue: NavigationQueue
  ) {
    self.createSpecimenState = createSpecimenState
    self.createModalState = createModalState
    self.createStackState = createStackState
    self.navigationQueue = navigationQueue.eraseToAnyNavigationQueue()
  }
  
  public convenience init() {
    self.init(navigationQueue: Environment.navigationQueue)
  }
  
  public convenience init<SpecimenDestination: Hashable & Identifiable & Sendable>(
    initialSpecimenDestination: SpecimenDestination
  ) {
    self.init(
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      navigationQueue: Environment.navigationQueue
    )
  }
  
  public static func `continue`(_ parent: Navigator) -> Navigator {
    let stackState = parent._stackState
    let navigationQueue = parent.navigationQueue
    
    return Navigator(
      createStackState: { stackState },
      navigationQueue: navigationQueue
    )
  }
  
  // MARK: - Specimen State
  
  public func replaceSpecimenDestination<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _specimenState] in
      _specimenState?.setDestination(destination)
    }
  }
  
  // MARK: Modal State
  
  public func presentDestination<Destination: DestinationType>(
    _ destination: ModalDestination<Destination>,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _modalState] in
      _modalState?.setDestination(destination)
    }
  }
  
  public func dismissDestination(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _modalState] in
      _modalState?.dismissDestination()
    }
  }
  
  // MARK: - Stack State
  
  // MARK: Push
  
  public func push<Destination: DestinationType>(
    _ destination: Destination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.append(destination, sourceFile: sourceFile, line: line)
    }
  }
  
  public func replaceLast<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    guard !_stackState.isEmpty else {
      return logWarning(
        """
          Can't replace last with `\(ShortDescription(destination))` since the stack is empty. \
          Ignoring `replaceLast`.
        """,
        file: sourceFile,
        line: line
      )
    }
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.append(destination, sourceFile: sourceFile, line: line)
    }
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: false
    ) { [weak _stackState] in
      _stackState?.removeLast(2, sourceFile: sourceFile, line: line)
      _stackState?.append(destination, sourceFile: sourceFile, line: line)
    }
  }
  
  public func replacePath<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    if _stackState.isEmpty {
      return await push(
        destination,
        animated: animated,
        sourceFile: sourceFile,
        line: line
      )
    }
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.append(destination, sourceFile: sourceFile, line: line)
    }
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: false
    ) { [weak _stackState] in
      _stackState?.removeAll(sourceFile: sourceFile, line: line)
      _stackState?.append(destination, sourceFile: sourceFile, line: line)
    }
  }
  
  // MARK: Pop
  
  public func pop(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    guard !_stackState.isEmpty else {
      return logWarning(
        """
          Trying to pop from empty stack. \
          Ignoring `pop`.
        """,
        file: sourceFile,
        line: line
      )
    }
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.removeLast(sourceFile: sourceFile, line: line)
    }
  }
  
  public func popToDestination<Destination: DestinationType>(
    _ destination: Destination,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    guard let index = _stackState.index(of: destination) else {
      return logWarning(
        """
          Destination `\(ShortDescription(destination))` is not present in the stack. \
          Ignoring `popToDestination`.
        """,
        file: sourceFile,
        line: line
      )
    }
    
    let itemsToRemove = _stackState.count - index - 1
    
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.removeLast(itemsToRemove, sourceFile: sourceFile, line: line)
    }
  }
  
  public func popToRoot(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _stackState] in
      _stackState?.removeAll(sourceFile: sourceFile, line: line)
    }
  }
}

extension Navigator {
  @_disfavoredOverload
  public func specimenDestination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Destination {
    _specimenState.destination(for: destinationType, sourceFile: sourceFile, line: line)
  }
  
  public func specimenDestination() -> AnyIdentifiableDestination {
    _specimenState._destination
  }
  
  @_disfavoredOverload
  public func modalDestination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> ModalDestination<Destination>? {
    _modalState.destination(for: destinationType, sourceFile: sourceFile, line: line)
  }
  
  public func modalDestination() -> ModalDestination<AnyIdentifiableDestination>? {
    _modalState._destination
  }
  
  public func stack() -> [AnyIdentifiableDestination] {
    _stackState.stack()
  }
}

extension Navigator: ModalStateDelegate {
  func modalStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    delegate?.navigatorDidDismissModalDestination(destination)
  }
}

extension Navigator: StackStateDelegate {
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    delegate?.navigatorDidDismissStackDestination(destination)
  }
}

@MainActor
public protocol NavigatorDelegate: AnyObject {
  func navigatorDidDismissModalDestination(_ destination: AnyIdentifiableDestination)
  func navigatorDidDismissStackDestination(_ destination: AnyIdentifiableDestination)
}

#if canImport(XCTest)

import Clocks

extension Navigator {
  static func test<Destination: SomeDestination>(
    specimenDestination: Destination? = nil,
    modalDestination: ModalDestination<Destination>? = nil,
    stack: [Destination] = [],
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Navigator {
    let navigator = Navigator(navigationQueue: NavigationQueue(clock: ImmediateClock()))
    
    if let specimenDestination {
      navigator._specimenState.setDestination(specimenDestination)
    }
    
    if let modalDestination {
      navigator._modalState.setDestination(modalDestination)
    }
    
    stack.forEach {
      navigator._stackState.append($0, sourceFile: sourceFile, line: line)
    }

    return navigator
  }
}

#endif
