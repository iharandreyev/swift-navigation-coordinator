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
  public func stack() -> [AnyIdentifiableDestination] {
    _stackState.stack()
  }
}
