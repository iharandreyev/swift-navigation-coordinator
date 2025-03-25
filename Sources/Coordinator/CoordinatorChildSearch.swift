//
//  CoordinatorChildSearch.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

public protocol CoordinatorChildSearch: CoordinatorBase {
  associatedtype DestinationType: ScreenDestinationType
}

extension CoordinatorChildSearch {
  public func child<
    Child: CoordinatorBase & ScreenCoordinatorType
  >(
    ofType: Child.Type = Child.self,
    for destination: DestinationType,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    guard let someChild = children[AnyDestination(destination)] else {
      fatalError(
        "Child for destination `\(ShortDescription(destination))` is not found in the children list",
        file: file,
        line: line
      )
    }
    guard let child = someChild as? Child else {
      fatalError(
        """
          Type mismatch! \
          Expected `\(ShortDescription(someChild))` to be 
          of type `\(ShortDescription(Child.self))`
        """,
        file: file,
        line: line
      )
    }
    return child
  }
  
  public func child(
    for destination: DestinationType
  ) -> CoordinatorBase? {
    children[AnyDestination(destination)]
  }
}
