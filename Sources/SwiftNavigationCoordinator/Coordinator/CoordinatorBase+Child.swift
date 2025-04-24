//
//  CoordinatorBase+Child.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#warning("TODO: Documentation")
extension CoordinatorBase {
  @discardableResult
  public func addChild<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    for destination: Destination,
    _ createChild: () -> Child,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Child {
    if let someChild = child(for: destination) {
      return cast(
        someChild,
        into: Child.self,
        invokedIn: file,
        at: line
      )
    }
    
    let child = createChild()
    
    addChild(
      child,
      for: destination,
      invokedIn: file,
      at: line
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
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Child {
    addChild(
      for: destination,
      {
        createChild(Navigator.continue(navigator))
      },
      invokedIn: file,
      at: line
    )
  }
  
  public func child<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    of childType: Child.Type = Child.self,
    for destination: Destination,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Child {
    guard let someChild = child(for: destination) else {
      fatalError(
        "Child for destination `\(ShortDescription(destination))` is not found in the children list",
        invokedIn: file,
        at: line
      )
    }
    
    return cast(
      someChild,
      into: Child.self,
      invokedIn: file,
      at: line
    )
  }
  
  @inline(__always)
  public func child<Destination: SomeDestination>(
    for destination: Destination
  ) -> CoordinatorBase? {
    children[AnyDestination(destination)]
  }
}
