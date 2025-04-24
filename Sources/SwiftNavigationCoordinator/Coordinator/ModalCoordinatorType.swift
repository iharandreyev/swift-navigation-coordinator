//
//  ModalCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

#warning("TODO: Documentation")
@MainActor
public protocol ModalCoordinatorType: NavigationCoordinatorType where ModalDestination: DestinationType { }

extension ModalCoordinatorType {
  public func presentDestination(
    _ destination: ModalDestinationPath<ModalDestination>,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.presentDestination(
      destination,
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
  
  public func dismissDestination(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigator.dismissDestination(
      animated: animated,
      invokedIn: file,
      at: line
    )
  }
}
