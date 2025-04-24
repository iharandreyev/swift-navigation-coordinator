//
//  ModalCoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@MainActor
public protocol ModalCoordinatorType: NavigationCoordinatorType where ModalDestination: DestinationType {

}

extension ModalCoordinatorType {
  public func presentDestination(
    _ destination: ModalDestinationPath<ModalDestination>,
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigator.presentDestination(
      destination,
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
  
  public func dismissDestination(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigator.dismissDestination(
      animated: animated,
      sourceFile: sourceFile,
      line: line
    )
  }
}
