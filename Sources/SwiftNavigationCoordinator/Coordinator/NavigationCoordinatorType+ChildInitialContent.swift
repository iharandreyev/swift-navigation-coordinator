//
//  NavigationCoordinatorType+ChildInitialContent.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/25/25.
//

import SwiftUI

#warning("TODO: Documentation")
extension NavigationCoordinatorType {
  @inline(__always)
  public func initialContent<
    Child: NavigationCoordinatorType,
    Destination: SomeDestination
  >(
    for destination: Destination,
    _ createChild: () -> Child,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> some View {
    addChild(
      for: destination,
      createChild,
      invokedIn: file,
      at: line
    )
    .initialContent()
  }
  
  @inline(__always)
  public func initialContent<
    Child: NavigationCoordinatorType,
    Destination: SomeDestination
  >(
    for destination: Destination,
    _ createChild: (Navigator) -> Child,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> some View {
    initialContent(
      for: destination,
      {
        createChild(Navigator.continue(navigator))
      },
      invokedIn: file,
      at: line
    )
  }
  
  @inline(__always)
  public func initialContent<
    Child: NavigationCoordinatorType,
    Destination: SomeDestination
  >(
    for destination: Destination,
    ofChild childType: Child.Type = Child.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> some View {
    child(
      of: childType,
      for: destination,
      invokedIn: file,
      at: line
    )
    .initialContent()
  }
}
