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
    Destination: ModalDestinationContentType,
    DestinationContent: View
  >(
    modalNavigator: ModalNavigator<Destination>,
    content: @escaping (Destination) -> DestinationContent
  ) -> some View {
    ModalContainer(
      modalNavigator: modalNavigator,
      root: { self },
      destinationContent: content
    )
  }
}
