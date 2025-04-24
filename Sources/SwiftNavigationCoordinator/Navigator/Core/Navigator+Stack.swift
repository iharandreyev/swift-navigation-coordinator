//
//  Navigator+Stack.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

extension Navigator {
  
  // MARK: Push
  
  public func push<Destination: DestinationType>(
    _ destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.append(destination, invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
  
  public func replaceLast<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    guard !_stackState.isEmpty else {
      return logWarning(
        """
          Can't replace last with `\(ShortDescription(destination))` since the stack is empty. \
          Ignoring `replaceLast`.
        """,
        invokedIn: file,
        at: line
      )
    }

    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.append(destination, invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )

    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.removeLast(2, invokedIn: file, at: line)
        _stackState?.append(destination, invokedIn: file, at: line)
      },
      animated: false,
      from: file,
      at: line
    )
  }
  
  public func replacePath<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    if _stackState.isEmpty {
      return await push(
        destination,
        animated: animated,
        invokedIn: file,
        at: line
      )
    }

    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.append(destination, invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )

    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.removeAll(invokedIn: file, at: line)
        _stackState?.append(destination, invokedIn: file, at: line)
      },
      animated: false,
      from: file,
      at: line
    )
  }
  
  // MARK: Pop
  
  public func pop(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    guard !_stackState.isEmpty else {
      return logWarning(
        """
          Trying to pop from empty stack. \
          Ignoring `pop`.
        """,
        invokedIn: file,
        at: line
      )
    }

    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.removeLast(invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
  
  @inline(__always)
  public func popToDestination<Destination: DestinationType>(
    _ destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await popToSomeDestination(
      destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  @_disfavoredOverload
  func popToSomeDestination<Destination: SomeDestination>(
    _ destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    guard let index = _stackState.index(of: destination) else {
      return logWarning(
        """
          Destination `\(ShortDescription(destination))` is not present in the stack. \
          Ignoring `popToDestination`.
        """,
        invokedIn: file,
        at: line
      )
    }
    
    let itemsToRemove = _stackState.count - index - 1

    
    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.removeLast(itemsToRemove, invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
  
  public func popToRoot(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      update: { [weak _stackState] in
        _stackState?.removeAll(invokedIn: file, at: line)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
}

extension Navigator {
  public func stack() -> [AnyDestination] {
    _stackState.stack()
  }
}
