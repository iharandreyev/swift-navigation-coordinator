//
//  View+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

extension View {
  @inline(__always)
  public func modal<
    Destination: DestinationType,
    DestinationContent: View
  >(
    navigator: Navigator,
    content: @escaping (Destination) -> DestinationContent
  ) -> some View {
    ModalContainer(
      navigator: navigator,
      root: { self },
      destinationContent: content
    )
  }
}
