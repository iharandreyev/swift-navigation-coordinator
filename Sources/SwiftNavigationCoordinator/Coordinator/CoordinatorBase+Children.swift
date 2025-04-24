//
//  CoordinatorBase+Children.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

extension CoordinatorBase {
  @discardableResult
  public func addChild<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    for destination: Destination,
    _ createChild: () -> Child,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    if let someChild = child(for: destination) {
      return cast(
        someChild,
        into: Child.self,
        sourceFile: sourceFile,
        line: line
      )
    }
    
    let child = createChild()
    
    addChild(
      child,
      for: destination,
      sourceFile: sourceFile,
      line: line
    )
    
    return child
  }
  
  @inline(__always)
  @discardableResult
  public func addChild<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    for destination: Destination,
    _ createChild: (Navigator) -> Child,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    addChild(
      for: destination,
      {
        createChild(Navigator.continue(navigator))
      },
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func child<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    of childType: Child.Type = Child.self,
    for destination: Destination,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    guard let someChild = child(for: destination) else {
      fatalError(
        "Child for destination `\(ShortDescription(destination))` is not found in the children list",
        sourceFile: sourceFile,
        line: line
      )
    }
    
    return cast(
      someChild,
      into: Child.self,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  @inline(__always)
  public func child<Destination: SomeDestination>(
    for destination: Destination
  ) -> CoordinatorBase? {
    children[AnyDestination(destination)]
  }
}
