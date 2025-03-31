//
//  View+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import CasePaths
import Perception
import SwiftUI
import SwiftUINavigation

private struct _ModalContainer<
  Root: View,
  Destination: ModalDestinationContentType,
  DestinationContent: View
>: ObservingView {
  @Perception.Bindable
  private var modalState: ModalState
  
  private let root: () -> Root
  private let destinationContent: (Destination) -> DestinationContent
  
  init(
    modalState: ModalState,
    root: @escaping () -> Root,
    destinationContent: @escaping (Destination) -> DestinationContent
  ) {
    self.modalState = modalState
    self.root = root
    self.destinationContent = destinationContent
  }
  
  var content: some View {
    return root()
      .sheet(
        item: $modalState.destinationOf(Destination.self).sheet,
        content: destinationContent
      )
      .cover(
        item: $modalState.destinationOf(Destination.self).cover,
        content: destinationContent
      )
  }
}

extension View {
  @inline(__always)
  func modal<
    Destination: ModalDestinationContentType,
    DestinationContent: View
  >(
    ofType destinationType: Destination.Type,
    from modalState: ModalState,
    content: @escaping (Destination) -> DestinationContent
  ) -> some View {
    _ModalContainer<Self, Destination, DestinationContent>(
      modalState: modalState,
      root: { self },
      destinationContent: content
    )
  }
}
